//
//  MyListsView.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-01-27.
//

import SwiftUI
import Firebase


struct MyListsView: View {
    @ObservedObject var userModel : ModelData
    @State var showMenu = false
    
    var body: some View {
        NavigationView {
            GeometryReader{ geometry in
                ZStack(alignment: .leading)
                {
                    MainView(entry: ShoppingListEntry(listName: "Bra dag"), item: Items(itemName: "", itemQty: "", itemQtyType: "", itemIsShopped: false))
                        .frame(width: geometry.size.width,height: geometry.size.height)
                        .offset(x: self.showMenu ? geometry.size.width/2:0)
                        .disabled(self.showMenu ? true:false)
                    
                    if self.showMenu{
                        SlidingMenuView(userModel: userModel)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                    }
                }
            }.navigationBarTitle("Shopping List", displayMode: .inline)
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation{
                        self.showMenu.toggle()
                    }
                }){
                    Image(systemName: "line.horizontal.3").imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                }
            ))
        }
    }
}

struct MainView : View
{
    @ObservedObject var shoppingList = ShoppingList()
    
    @State var addNewListAlert = false
    @State var ediShoppingListAlert = false
    @State private var listName: String = ""
    var entry : ShoppingListEntry
    var db = Firestore.firestore()
    @State var docID : String = ""
    @State var itemDocID : String = ""
    var item:Items
    @State private var showingAlert = false
    var body: some View
    {
        VStack{
            NavigationView {
                List(){
                    ForEach(shoppingList.entries) { entry in
                        NavigationLink(
                            destination: ShoppingListItemView(listEntry: entry, item: item)){
                            ShoppingListCardView(entry: entry)
                        }        .contextMenu{
                            Button(action: {
                                docID = entry.docId!
                                self.ediShoppingListAlert = true
                            }) {
                                Text("Edit")
                            }
                            
                            Button(action: {
                                docID = entry.docId!
                                print(itemDocID)
                                self.showingAlert = true
                            }) {
                                Text("Delete")
                            }
                        }.alert(isPresented:$showingAlert)
                        {
                                    Alert(
                                        title: Text("Are you sure you want to delete this?"),
                                        message: Text("There is no undo"),
                                        primaryButton: .destructive(Text("Delete")) {
                                         //   deleteListInDB()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                    }
                   // .onDelete(perform: self.deleteListInDB)
                }
                .navigationBarTitle("Lists")
                .navigationBarItems(trailing: Button(action: {
                    self.addNewListAlert = true
                }){
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                        .frame(width: 55, height: 55)
                })
            }
            .onAppear() {
                shoppingList.fetchListFromDatabase()
            //shoppingList.fetchItemDocId()
            }
        }
        AddNewListAlertView(title: "Enter name of the list", isShown: $addNewListAlert, listName: $listName, onAdd: {_ in
            saveShoppingListInDB()
        })
        EditShoppingListAlertView(title: "Enter name of the list", isShown: $ediShoppingListAlert, listName: $listName, onAdd: {_ in
            updateShoppingListInDB()
        })
    }
    
    
    func saveShoppingListInDB(){
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").addDocument(data: ["listName": listName]) { error in
            if let error = error{
                print("error")
            } else{
                print ("Data is inserted")
            }
        }
    }
    
    func updateShoppingListInDB(){
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").document(docID).updateData(["listName" : listName])
        { error in
            if let error = error{
                print("error")
            } else{
                print ("Data is inserted")
            }
        }
    }
    func deleteListInDB(){
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").document(docID).delete()
        { error in
            if let error = error{
                print("error")
            } else{
                print ("")
            }
        }
        db.collection("Users").document(currentUser).collection("Lists").document(docID)
            .collection("Items").document(itemDocID).delete()
        { error in
            if let error = error{
                print("error")
            } else{
                print ("")
            }
        }
    }
   /* func deleteListInDB(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let shoppingListDocId = shoppingList.entries[index]
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
            db.collection("Users").document(currentUser).collection("Lists").document(shoppingListDocId.docId!).delete{
            error in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("deleteSuccess")
            }
        }
            // Delete the Items of the Shopping list
            /*db.collection("Users").document(currentUser).collection("Lists").document(shoppingListDocId.docId!).collection("Item").document("sBNYoe4a9zXBVDP96Zs6").delete{
            error in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("deleteSuccess")
            }
        }*/
    }
}*/
}

struct MyListsView_Previews: PreviewProvider {
    static var previews: some View {
        MyListsView(userModel: ModelData())
    }
}
