//
//  ShoppingListItemView.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-02.
//

import SwiftUI
import Firebase


struct ShoppingListItemView : View {
    
   /* var item : Items? = nil
    var newItemEntries:ItemsModel */
    
    @State var listEntry : ShoppingListEntry
    @ObservedObject var listEntries = ShoppingListName()
   // @ObservedObject var itemModel = ItemsModel()
      
   
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
                    //.frame(width: 100, height: 40)
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
                }.padding(.leading, 100)
                Button(action: self.addNewItem, label: {
                     Text("ADD")
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.title3)
                        .cornerRadius(5)
                        .padding(.bottom,20)
                 })
            }.padding()
              
        }.frame(width:  UIScreen.main.bounds.width - 32, height: 200, alignment: .top)
        .background(Color.pink)
        .cornerRadius(10)
        .shadow(radius:8)
        //Alert if no values entered in textfield
        .alert(isPresented: self.$showErrorMessage) {
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
                            RowView(entry: items)
                           
                            }.onDelete(perform: self.deleteItem(at:))
                            
                    }.onAppear(){ fetchItemsFromDB() }
                        .navigationBarTitle("\(self.listEntry.listName)",displayMode: .inline)
                       .navigationBarItems(trailing:
                        Button(action: {
                            print("Navigation Add button pressed...")
                            self.isItemAddCardShown.toggle()
                            print("ListName:\(self.listEntry.listName)")
                            print("List docID: \(self.$listEntry.docId)")
                        }) {
                                           
                            Image(systemName: "plus.circle")
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
            
            //newItemEntries.itemModel.append(newItemEntry)
            self.listEntry.eachListItems.append(newItemEntry)
            
            saveItemToDB()
            clearFields()
            
           /* itemModel.listDocID = self.listEntry.docId ?? ""
            self.itemModel.addItems(self.newItem,self.newItemQty,self.newQtyType[selectedPickerValue],self.newItemIsShopped)*/
          }
      }
    
    func clearFields(){
        self.newItem = ""
        self.newItemQty = "0"
    }
    
    func deleteItem(at indexSet: IndexSet){
        listEntry.eachListItems.remove(atOffsets: indexSet)
       /* guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").document(self.listEntry.docId!).collection("Items").document()*/
    }
    
    //Function adds item to DB
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
    //@State var entry: ShoppingListEntry
   // @Binding var entry: Items
    
    var body: some View {
        ScrollView{
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 2)
                    .fill(LinearGradient(gradient: Gradient(colors:[Color.green,Color.blue]),startPoint: .topLeading,endPoint: .bottomTrailing))
                        .padding(.horizontal, 4)
                        .shadow(color: Color.black, radius: 3, x: 3, y: 3)

            HStack(){
                Button(action: {
                    print("Checkbox clicked")
                    self.entry.itemIsShopped.toggle()
                    
                },label: {
                    Image(systemName: self.entry.itemIsShopped ? "checkmark.square.fill" : "square")
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                        .padding()
                })
               
               // TextEditor(text: self.$entry.itemName)
                Text(self.entry.itemName).fontWeight(.bold).font(.body)
                
                Spacer()
                //TextEditor(text: self.$entry.itemQty)
                Text(self.entry.itemQty).font(.body)
                //TextEditor(text: self.$entry.itemQtyType)
                Text(self.entry.itemQtyType).font(.body).padding()
            }
            }
            }
        }
}
    
}


struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListItemView(listEntry: ShoppingListEntry(listName: "Good day"))
    }
}
