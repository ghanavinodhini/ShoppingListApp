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
    
    @State var showMenu = false
    
        @State private var listName: String = ""
        var db = Firestore.firestore()
    
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
                    withAnimation{
                        self.showMenu.toggle()
                    }
                }){
                    Image(systemName: "line.horizontal.3").imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                }
            ))
        }
        
        /*NavigationView
        {
            ZStack{
                Text("Hello World").padding()
           
            }.navigationBarTitle("Welcome \(userModel.currentUserName)")
            .navigationBarTitleDisplayMode(.inline)
        }*/
        
        
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
         /*               NavigationLink(
                            destination: ListItemView(list: list, entry: itemEntry, entry1: entry)) {*/
                        RowView(entry: entry)
                       // ShoppingListCardView(entry: entry)
                                .contextMenu{
                                    VStack{
                                        
                                        Button(action: {
                                            self.editShoppingListAlert = true
                                            EditShoppingListAlertView(title: "Enter name of the list", isShown: $editShoppingListAlert, listName: $listName, onAdd: {_ in
                                            //saveListInDB()
                                    })
                                            
                                       }) {
                                            Text("Edit")
                                        }
                                     
                                        Button(action: {
                                            // enable geolocation
                                            
                                        }) {
                                            Text("Cancel")
                                        }
                                        
                                    }
                                }
                   // .onDelete(perform: self.deleteListInDB)
                    }/*.onDelete(perform: { indexSet in
                        list.entries.remove(atOffsets: indexSet)
                        if let documentId = entry.docId{
                        db.collection("List").document(documentId).delete{
                            error in
                            if let error = error{
                                print(error.localizedDescription)
                            } else {
                                //self.list.fetchListFromDatabase()
                            }
                        }
                           
                    }
                        
                       })*/
                    .onDelete(perform: self.deleteListInDB)
                
                }
                .navigationBarTitle("Lists")
            }
            .onAppear() {
                list.fetchListFromDatabase()
            }
            
        }

        
            VStack{
                Spacer(minLength: 500)
                HStack{
                Spacer()
                    ZStack{
        Button(action: {
            //addNewListAlert = true
            self.addNewListAlert.toggle()
            
        }) {
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .frame(width: 75, height: 75, alignment: .bottomLeading)
        }
                    AddNewListAlertView(title: "Enter name of the list", isShown: $addNewListAlert, listName: $listName, onAdd: {_ in
                    saveShoppingListInDB()
            })
                        
                        
                    }
                   
        }
                Button(action: {
                    self.editShoppingListAlert.toggle()
                }) {
                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                }
                EditShoppingListAlertView(title: "Enter name of the list", isShown: $editShoppingListAlert, listName: $listName, onAdd: {_ in
                  //  saveListInDB()
            })
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
    func editShoppingListInDB(){
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).setData(["listName" : listName]) { error in
        if let error = error{
            print("error")
        } else{
        print ("Data is updated")
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
          /*  func deleteListInDB(at indexSet: IndexSet){
            //indexSet.forEach {index in
            //  let task = self.$list[index]
            db.collection("List").document("1iFUJgUkxIkx2uB3aai9").delete{
                error in
                if let error = error{
                    print(error.localizedDescription)
                    print("Hello")
                } else {
                    //self.list.fetchListFromDatabase()
                    print("deleteSuccess")
                    
                }
            }
        }*/
        

struct RowView : View {
    
    var entry : ShoppingListEntry
    
    /*var date : String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        let date = formatter.string(from: entry.date)
        return date
    }*/
    
    var body: some View {
        HStack {
            //Text(date)
            Spacer()
            Text(entry.listName)
        }
    }
}



struct MyListsView_Previews: PreviewProvider {
    static var previews: some View {
        //MyListsView(userModel: ModelData(), entry: ListEntry(listTitle: "Bra //dag"))
        MyListsView(userModel: ModelData())
    }
}
