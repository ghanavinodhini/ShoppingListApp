//
//  MyListsView.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-01-27.
//

import SwiftUI
import Firebase


struct MyListsView: View {
    //@EnvironmentObject var userModel : ModelData
    @ObservedObject var userModel : ModelData
    // @Environment(\.presentationMode) var presentationMode
    @ObservedObject var list = ShoppingListName()
    var entry : ShoppingListEntry
    @State var showMenu = false
    @State var rowView = RowView(entry: ShoppingListEntry(listName: "Bra dag"))
    @State var addNewListAlert = false
    //   @State private var listName: String = ""
    var db = Firestore.firestore()
    // @State var addNewListAlert = false
    @State private var listName: String = ""
    var body: some View {
        NavigationView {
            GeometryReader{ geometry in
                ZStack(alignment: .leading)
                {
                    //MainView(showMenu: self.$showMenu)
                    MainView(entry: ShoppingListEntry(listName: "Bra dag"))
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
                    print("entry\(entry.docId)")
                    withAnimation{
                        self.showMenu.toggle()
                    }
                }){
                    Image(systemName: "line.horizontal.3").imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                }
            ), trailing: (
                Button(action: {
                
                self.addNewListAlert = true
            })
            {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            }))
            
        }
        
        /*NavigationView
         {
         ZStack{
         Text("Hello World").padding()
         
         }.navigationBarTitle("Welcome \(userModel.currentUserName)")
         .navigationBarTitleDisplayMode(.inline)
         }*/
        
        AddNewListAlertView(title: "Enter name of the list", isShown: $addNewListAlert, listName: $listName, onAdd: {_ in
           // saveShoppingListInDB()
        })
    }
    
}

struct MainView : View
{
    //@Binding var showMenu:Bool
    
    @ObservedObject var list = ShoppingListName()
    @State var addNewListAlert = false
    @State var editShoppingListAlert = false
    @State private var listName: String = ""
    var entry : ShoppingListEntry
    var db = Firestore.firestore()
    @State var rowView = RowView(entry: ShoppingListEntry(listName: "Bra dag"))
    
    var body: some View
    {
        /*  Button(action: {
         withAnimation{
         self.showMenu = false
         }
         }){
         Text("Hello")
         }*/
        
        VStack{
            NavigationView {
                List(){
                    ForEach(list.entries) { entry in
                        NavigationLink(
                            destination: ShoppingListItemView()) {
                            //ShoppingListCardView(entry: entry)
                          //  ShoppingListCardView()
                            RowView(entry: entry)
                        }       /* .contextMenu{
                            Button(action: {
                                self.editShoppingListAlert = true
                                print("Hello")
                            }) {
                                Text("Edit")
                            }
                    
                            Button(action: {
                                
                            }) {
                                Text("Cancel")
                            }
                        }*/
                    }
                    
                }
                .navigationBarTitle("Lists")
                
            }
            .onAppear() {
                list.fetchListFromDatabase()
            }
        }
        
           
            HStack{
                ZStack{
                    Button(action: {
                        print("entry\(entry.docId)")
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
                    EditShoppingListAlertView(title: "Enter name of the list1", isShown: $editShoppingListAlert, listName: $listName, onAdd: {_ in
                       // updateShoppingListInDB()
                      //  rowView.edit()
                        guard let currentUser = Auth.auth().currentUser?.uid else { return }
                        if let docId = entry.docId {
                            print("edit")
                            db.collection("Users").document(currentUser).collection("Lists").document(docId).updateData(["listName" : listName]) { error in
                            if let error = error{
                                print("error")
                            } else{
                                print ("Data is inserted")
                            }
                        }
                        }
                      
                    })
                    
                }

            }
    }
    
    func saveShoppingListInDB(){
        print(entry.docId)
        print(list.docId)
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
        /*guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").setValue(listName, forKey: "listName")*/
    guard let currentUser = Auth.auth().currentUser?.uid else { return }
    if let docId = entry.docId{
    db.collection("Users").document(currentUser).collection("Lists").document(entry.docId!).setData(["listName" : listName]) { error in
        if let error = error{
            print("error")
        } else{
            print ("Data is updated")
        }
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

struct RowView : View {
    @State private var listName: String = ""
    var entry : ShoppingListEntry
    @State var editShoppingListAlert = false
    var db = Firestore.firestore()
    var body: some View {
        
        HStack {
            //Text(entry.docId!)
           // Spacer()
            Text(entry.listName)
                .contextMenu{
                  Button(action: {
                      self.editShoppingListAlert = true
                      print("Hello")
                    EditShoppingListAlertView(title: "Enter name of the list1", isShown: $editShoppingListAlert, listName: $listName, onAdd: {_ in
                       // updateShoppingListInDB()
                      //  rowView.edit()
                        /*guard let currentUser = Auth.auth().currentUser?.uid else { return }
                        print(currentUser)
                        if let docId = entry.docId {
                            print("edit")
                            db.collection("Users").document(currentUser).collection("Lists").document(docId).updateData(["listName" : listName]) { error in
                            if let error = error{
                                print("error")
                            } else{
                                print ("Data is inserted")
                            }
                        }
                        }*/
                      
                    })
                    
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

}


struct MyListsView_Previews: PreviewProvider {
    static var previews: some View {
        //MyListsView(userModel: ModelData(), entry: ListEntry(listTitle: "Bra //dag"))
        MyListsView(userModel: ModelData(), entry: ShoppingListEntry(listName: "Bra dag"))
    }
}
