//
//  ShoppingListItemView.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-02.
//

import SwiftUI
import Firebase


struct ShoppingListItemView : View {
    
    @State var listEntry : ShoppingListEntry
    @ObservedObject var listEntries = ShoppingListName()
    
      @State var newItem:String = ""
      @State var showErrorMessage = false
    
    @State var newItemQty:String = "0"
    @State var newQtyType = ["KG","Grams","Pcs","Boxes","Bottles","Cans"]
    @State var selectedPickerValue = 0
    @State var newItemIsShopped:Bool = false
    
    var db = Firestore.firestore()
    //Text field for adding new item
      var itemTextBar : some View{
          HStack{
            TextField("Enter New Item",text:self.$newItem)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(Color.black)
            
              //Alert if no values entered in textfield
          }.alert(isPresented: self.$showErrorMessage) {
              Alert(title: Text("Error"), message: Text("Please enter some Item!"), dismissButton: .default(Text("OK")))
          }
      }
    
   

    
    var body: some View {
       
            VStack{
                       itemTextBar.padding()
        VStack{
            HStack{
                Text("Qty:")
                TextField("Qty", text:$newItemQty)
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
            }
            Button(action: self.addNewItem, label: {
                 Text("ADD")
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                    .cornerRadius(40)
             })
        }.padding()
        }
        
        //List UI
            VStack(alignment: .leading){
                       List{
                        //ForEach(self.listEntry.eachListItems)
                        ForEach(self.listEntry.eachListItems)
                           {
                               items in
                           
                            RowView(entry: items)
                           }
                           .onDelete(perform: { indexSet in
                            listEntry.eachListItems.remove(atOffsets: indexSet)
                           })
                           
                       }
                       .navigationBarTitle("\(self.listEntry.listName)",displayMode: .inline)
                       .navigationBarItems(trailing:
                                       Button(action: {
                                           print("Save button pressed...")
                                        print("ListName:\(self.listEntry.listName)")
                                        print("List docID: \(self.$listEntry.docId)")
                                       }) {
                                           Text("SAVE")
                                       }
                                   )
            }.onAppear(){
                fetchItemsFromDB()
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
            
            self.listEntry.eachListItems.append(Items(itemName: newItem, itemQty: newItemQty,itemQtyType: newQtyType[selectedPickerValue],itemIsShopped: newItemIsShopped))
            saveItemToDB()
           // listEntry.eachListItems.append(Items(itemName: newItem, itemQty: "0"))
            clearFields()
            
          }
      }
    
    func clearFields(){
        self.newItem = ""
        self.newItemQty = "0"
    }
    
    //Function adds item to DB
    func saveItemToDB(){
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").document(self.listEntry.docId!).collection("Items").addDocument(data: ["Item Name":newItem, "Item Qty": newItemQty, "Item Qty Type": newQtyType[selectedPickerValue], "Item IsShopped": newItemIsShopped])
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
                    let itemDocId = document.documentID
                    let itemNameData = data["Item Name"] as? String ?? ""
                    let itemQtyData = data["Item Qty"] as? String ?? ""
                    let itemQtyTypeData = data["Item Qty Type"] as? String ?? ""
                    let itemIsShoppedData = data["Item IsShopped"] as? Bool ?? false
                    let ItemData = Items(id: itemDocId, itemName: itemNameData, itemQty: itemQtyData, itemQtyType: itemQtyTypeData, itemIsShopped: itemIsShoppedData)
                    
                    self.listEntry.eachListItems.append(ItemData)
                   /* let itemData = Items(id: document.documentID, itemName: document.get("Item Name") as! String, itemQty: document.get("Item Qty") as! String, itemQtyType: document.get("Item Qty Type"), itemIsShopped: document.get("Item IsShopped"))*/
                   
                }
            }
            
        }
    }
}

    
    
struct RowView: View{
   @State var entry: Items
    
    var body: some View {
        ScrollView{
        VStack{
            HStack(){
                Button(action: {
                    print("Checkbox clicked")
                    self.entry.itemIsShopped.toggle()
                    
                },label: {
                    Image(systemName: self.entry.itemIsShopped ? "checkmark.square" : "square")
                })
               
                Text(self.entry.itemName).fontWeight(.bold)
                Spacer()
                Text(self.entry.itemQty)
                Text(self.entry.itemQtyType)
            }
            
           /* HStack{
                Text("Qty:")
                TextField("Qty", text:$itemQty)
                    .keyboardType(.numbersAndPunctuation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.blue)
                    .fixedSize()
                Spacer()
           
                
                Picker(selection: $selectedPickerValue, label: Text("Choose Value")) {
                            ForEach(0 ..< qtyType.count) {
                               Text(self.qtyType[$0])
                            }
                }.frame(height: 50)
                .frame(width: 40)
                .scaledToFit()
                .scaleEffect(CGSize(width: 0.8, height: 0.8))
                
                //Text("You selected: \(qtyType[selectedPickerValue])")
            }.padding()*/
            
            }
        }
}
    
   /* func saveItemData(){
        listEntry.eachListItems.append(Items(itemName: newItem, itemQty: "0"))
        
    }*/
}


struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListItemView(listEntry: ShoppingListEntry(listName: "Good day"))
    }
}
