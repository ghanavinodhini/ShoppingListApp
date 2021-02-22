//
//  MyListsView.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-01-27.
//

import SwiftUI
import Firebase


struct MyListsView: View {
    @ObservedObject var userModel : UserModelData
    @State var showMenu = false
    
    var body: some View {
        NavigationView {
            GeometryReader{ geometry in
                ZStack(alignment: .leading)
                {
                    MainView(entry: ShoppingListEntry(listName: "Bra dag", dueDate: ""), item: Items(itemName: "", itemQty: "", itemQtyType: "", itemIsShopped: false), dueDate: "")
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
    var item:Items
    // Added for Notification functionality, due date variables
    @State var dueDate : String = ""
    @State var showFootnote = false
    var date : String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let date = formatter.string(from: entry.date)
        return date
    }
    var body: some View
    {
        VStack{
            NavigationView {
                List(){
                    ForEach(shoppingList.entries) { entry in
                        NavigationLink(
                            destination: ShoppingListItemView(listEntry: entry, item: item, itemDocId: "")){
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
                                print(docID)
                            }) {
                                Text("Cancel")
                            }
                        }
                    }
                    .onDelete(perform: self.deleteListInDB)
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
            }
        }
        AddNewListAlertView(title: "Enter name of the list", isShown: $addNewListAlert, listName: $listName, onAdd: {_ in
            saveShoppingListInDB()
            // Added for Notification functionality
            if self.dueDate == date {
                let localNotificationManager = LocalNotificationManager()
                localNotificationManager.sendNotification(title: "HI", subtitle: nil, body: "Hello", launchIn: 5)
            }
        }, dueDate: $dueDate)
        
        EditShoppingListAlertView(title: "Enter name of the list", isShown: $ediShoppingListAlert, listName: $listName, onAdd: {_ in
            updateShoppingListInDB()
        })
    }
    
    func saveShoppingListInDB(){
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").addDocument(data: ["listName": listName, "dueDate": dueDate]) { error in
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
    func deleteListInDB(at indexSet: IndexSet) {
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
}
}

struct MyListsView_Previews: PreviewProvider {
    static var previews: some View {
        MyListsView(userModel: UserModelData())
    }
}
