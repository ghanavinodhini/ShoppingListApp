//
//  ShoppingListItemView.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-02.
//

import SwiftUI
import Firebase


struct ShoppingListItemView : View {
    
    @EnvironmentObject var userModel : ModelData
    @State var listEntry : ShoppingListEntry
    
    @State var item : Items
    @State var newItem:String = ""
    @State var showErrorMessage = false
    @State var newItemQty:String = "0"
    @State var newQtyType = ["KG","Grams","Pcs","Boxes","Packets","Bunches","Bottles","Cans"]
    @State var selectedPickerValue = 0
    @State var newItemIsShopped:Bool = false
    @State var isItemAddCardShown:Bool = false
    
    var db = Firestore.firestore()
   
    //Text field for adding new item
      var itemTextBar : some View{
       
        VStack{
            ZStack(){
            Rectangle().foregroundColor(Color(.white))
                .cornerRadius(5)
                .frame(width: UIScreen.main.bounds.width - 35,height:40)
            HStack{
                TextField("Enter New Item",text:self.$newItem)
                    .padding().foregroundColor(.black)
                
            Spacer()
            
                Button(action: {
                    print("mic button pressed")
                }) {
                Image(systemName: "mic")
                    .font(Font.system(size:15).weight(.bold)).padding()
                    .frame(width:40,height:40)
                    .foregroundColor(.white)
                    .background(Color(.systemIndigo))
                    .cornerRadius(5)
                }
                }.padding(.horizontal)
            }
            VStack{
                HStack{
                    Text("Qty:")
                    TextField("Qty", text:self.$newItemQty)
                        .keyboardType(.numbersAndPunctuation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.blue)
                        .fixedSize()
                Spacer()
                
                    Picker(selection: $selectedPickerValue, label: Text("Choose Value")) {
                                ForEach(0 ..< newQtyType.count) {
                                   Text(self.newQtyType[$0])
                                }
                    }.frame(height: 50)
                    .frame(width: 40)
                    .scaledToFit()
                    .scaleEffect(CGSize(width: 0.8, height: 0.8))
                    .foregroundColor(.white)
                    .pickerStyle(WheelPickerStyle())
                    .padding()
                }.padding(.leading, 60)
                
                Button(action: self.addNewItem, label: {
                     Text("ADD")
                        .background(Color(.darkGray))
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.bottom,50)
                 })
            }.padding()
              
        }.frame(width:  UIScreen.main.bounds.width - 32, height: 200, alignment: .top)
        .background(Color(.systemTeal))
        .cornerRadius(10)
        .shadow(radius:8)
        
        //Alert if no values entered in textfield
        .alert(isPresented: self.$showErrorMessage)
        {
            Alert(title: Text("Error"), message: Text("Please enter some Item!"), dismissButton: .default(Text("OK")))
        }
    }
    
   
    var body: some View
    {
        if self.isItemAddCardShown
        {
                itemTextBar.padding()
        }
            //List UI
            VStack(alignment: .leading)
            {
                List
                    {
                        ForEach(self.listEntry.eachListItems)
                           {
                               items in
                            RowView(entry: items, listEntry: $listEntry)
                           
                        }.onDelete(perform: self.deleteItem(at:))
                        .id(UUID())
                            
                    }.onAppear(){ fetchItemsFromDB() }
                        .navigationBarTitle("\(self.listEntry.listName)",displayMode: .inline)
                       .navigationBarItems(trailing:
                        Button(action: {
                            print("Navigation ItemAdd button pressed...")
                            self.isItemAddCardShown.toggle()
                            print("ListName:\(self.listEntry.listName)")
                            print("List docID: \(self.$listEntry.docId)")
                        }) {
                            Image(systemName: "cart.badge.plus") .font(Font.system(size:30))
                        })
            }
    }
    
    //Function adds item to items list array
      func addNewItem()
      {
          if self.newItem.isEmpty
          {
              self.showErrorMessage.toggle()
            return
          }else{
              self.showErrorMessage = false
                let newItemEntry = Items(itemName: self.newItem, itemQty: self.newItemQty, itemQtyType: self.newQtyType[selectedPickerValue], itemIsShopped: self.newItemIsShopped)
            
            self.listEntry.eachListItems.append(newItemEntry)
            
            saveItemToDB()
            clearFields()
            
          }
      }
    
    func clearFields(){
        self.newItem = ""
        self.newItemQty = "0"
    }
    
    func deleteItem(at indexSet: IndexSet)
    {
        print("Inside delete item function")
        listEntry.eachListItems.remove(atOffsets: indexSet)
    }
    
    // Adds item to DB
    func saveItemToDB(){
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").document(self.listEntry.docId!).collection("Items").addDocument(data: ["Item Name":newItem, "Item Qty": newItemQty, "Item Qty Type": newQtyType[selectedPickerValue], "Item IsShopped": newItemIsShopped]){ error in
            if let error = error{
                print("Error saving document: \(error)")
            }else{
               print("Data is inserted")
            }
            
        }
    }
    
    //Get All Items For List
    func fetchItemsFromDB(){
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").document(self.listEntry.docId!).collection("Items").getDocuments(){ (snapshot, err) in
            if let err = err{
                print("Error getting document: \(err)")
            }else{
                for document in snapshot!.documents{
                    print("\(document.documentID) : \(document.data())")
                    
                    let data = document.data()
                    let itemDocIdData = document.documentID
                    let itemNameData = data["Item Name"] as? String ?? ""
                    let itemQtyData = data["Item Qty"] as? String ?? ""
                    let itemQtyTypeData = data["Item Qty Type"] as? String ?? ""
                    let itemIsShoppedData = data["Item IsShopped"] as? Bool ?? false
                    let ItemData = Items(itemDocid: itemDocIdData, itemName: itemNameData, itemQty: itemQtyData, itemQtyType: itemQtyTypeData, itemIsShopped: itemIsShoppedData)
                    
                    self.listEntry.eachListItems.append(ItemData)
                }
            }
            
        }
    }
}

    
    
struct RowView: View{
   @State var entry: Items
    
    @Binding var listEntry : ShoppingListEntry
    var db = Firestore.firestore()
    
    var body: some View {
        ScrollView{
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 2)
                    .fill(LinearGradient(gradient: Gradient(colors:[Color.white,Color.green]),startPoint: .topLeading,endPoint: .bottomTrailing))
                        .padding(.horizontal, 4)
                        .shadow(color: Color.black, radius: 3, x: 3, y: 3)

            HStack(){
                Button(action: {
                    print("Checkbox clicked")
                    self.entry.itemIsShopped.toggle()
                    print("ItemIsShooped value after click: \(self.entry.itemIsShopped)")
                    guard let itemId = self.entry.itemDocid else {return}
                    itemSelectedUpdateInDB(itemId)
                    
                },label: {
                    Image(systemName: entry.itemIsShopped ? "checkmark.square.fill" : "square").font(Font.system(size:20))
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                        .padding()
                })
               
               // TextEditor(text: self.$entry.itemName)
                
                entry.itemIsShopped ? Text(self.entry.itemName).fontWeight(.bold).font(.body).strikethrough(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, color: /*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/) :
                Text(self.entry.itemName).fontWeight(.bold).font(.body)
                
                Spacer()
                //TextEditor(text: self.$entry.itemQty)
                entry.itemIsShopped ?
                    Text(self.entry.itemQty).font(.body).strikethrough(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, color: /*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/) :
                Text(self.entry.itemQty).font(.body)
                
                //TextEditor(text: self.$entry.itemQtyType)
                entry.itemIsShopped ?
                    Text(self.entry.itemQtyType).font(.body).strikethrough(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, color: /*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/).padding() :
                    Text(self.entry.itemQtyType).font(.body).padding()
            }
            }
            }
        }
}
    
    func itemSelectedUpdateInDB(_ itemId:String)
    {
            print("Value of list docId: \(self.listEntry.docId!)")
            print("Value itemShopped inside function: \(self.entry.itemIsShopped)")
            print("Item Doc id inside function: \(String(describing: itemId))")
            
            guard let currentUser = Auth.auth().currentUser?.uid else { return }
            db.collection("Users").document(currentUser).collection("Lists").document(self.listEntry.docId!).collection("Items").document(itemId).updateData(["Item IsShopped":self.entry.itemIsShopped]){ error in
                if let error = error{
                    print("Error updating document for item selected : \(error)")
                }else{
                   print("Updated item document for item selection")
                }
            }
    }
}


struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListItemView(listEntry: ShoppingListEntry(listName: "Good day"), item: Items(itemName: "", itemQty: "", itemQtyType: "", itemIsShopped: false))
    }
}
