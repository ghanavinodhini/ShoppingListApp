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
    
    var db = Firestore.firestore()
   // @State var addNewListAlert = false
    
    var body: some View {
         NavigationView {
            GeometryReader{ geometry in
                ZStack(alignment: .leading)
                {
                    MainView(entry: ShoppingListEntry(listName: "Bra dag"), item: Items(itemName: "", itemQty: "", itemQtyType: "", itemIsShopped: false))
                        .frame(width: geometry.size.width,height: geometry.size.height)
                        .offset(x: self.showMenu ? CGFloat(Int(geometry.size.width/2)):0)
                        .disabled(self.showMenu ? true:false)
                    
                    if self.showMenu{
                        SlidingMenuView(userModel: userModel)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                    }
            
                }
            }
            .navigationBarTitle("Shopping List", displayMode: .inline)
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
        @ObservedObject var list = ShoppingListName()
        @State var addNewListAlert = false
        @State private var listName: String = ""
        var entry:ShoppingListEntry
        var db = Firestore.firestore()
    
        var item:Items
    
    var body: some View
    {
        NavigationView {
        VStack{
            //NavigationView {
                List(){
                    ForEach(list.entries) { entry in
                     NavigationLink(
                        destination: ShoppingListItemView(listEntry: entry, item: item)) {
                        ShoppingListCardView(entry: entry)
                        }        .contextMenu{
                                        Button(action: {
                                       }) {
                                            Text("Edit")
                                        }
                                        
                                        Button(action: {
                                            
                                        }) {
                                            Text("Cancel")
                                        }
                                }
                    }
                }
                .navigationBarTitle("Lists")
                
            }
            .onAppear() {
                list.fetchListFromDatabase()
            }
            
        }
            VStack{
                Spacer()
                HStack{
                    ZStack{
        Button(action: {
            
            self.addNewListAlert.toggle()
            
        }) {
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .frame(width: 75, height: 75)
        }
                    AddNewListAlertView(title: "Enter name of the list", isShown: $addNewListAlert, listName: $listName, onAdd: {_ in
                         
                        saveShoppingListInDB()
            })
                    }
                   
        }
               
        }

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
    func deleteListInDB(at indexSet: IndexSet){
        indexSet.forEach {index in
            let task = list.entries[index]
        if let documentId = entry.docId{
        db.collection("List").document(documentId).delete{
            error in
            if let error = error{
                print(error.localizedDescription)
            } else {
                //self.list.fetchListFromDatabase()
                print("deleteSuccess")
            }
        }
    }
}
    }
    }


struct MyListsView_Previews: PreviewProvider {
    static var previews: some View {
        //MyListsView(userModel: ModelData(), entry: ListEntry(listTitle: "Bra //dag"))
        MyListsView(userModel: ModelData())
    }
}
