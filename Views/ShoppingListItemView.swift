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
    
    @State var itemQty:String = "0"
    @State var qtyType = ["KG","Grams","Pcs","Boxes","Bottles","Cans"]
    @State var selectedPickerValue = 0
    var db = Firestore.firestore()
    //Text field for adding new item
      var itemTextBar : some View{
          HStack{
            TextField("Enter New Item",text:self.$newItem)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(Color.black)
             /* Button(action: self.addNewItem, label: {
                  Text("ADD")
                  
              })*/
              //Alert if no values entered in textfield
          }.alert(isPresented: self.$showErrorMessage) {
              Alert(title: Text("Error"), message: Text("Please enter some Item!"), dismissButton: .default(Text("OK")))
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
            listEntry.eachListItems.append(Items(itemName: newItem, itemQty: itemQty,itemQtyType: qtyType[selectedPickerValue]))
            saveItemToDB()
           // listEntry.eachListItems.append(Items(itemName: newItem, itemQty: "0"))
          self.newItem = ""
            self.itemQty = "0"
          }
      }
    
    //Function adds item to DB
    func saveItemToDB(){
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").document(self.listEntry.docId!).collection("Items").addDocument(data: ["Item Name":newItem, "Item Qty": itemQty, "Item Qty Type": qtyType[selectedPickerValue]])
    }

    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius:10,style:.continuous).fill(Color.white)
            VStack{
                       itemTextBar.padding()
                      
        VStack{
            HStack{
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
        }
        
        
        
            VStack(alignment: .leading){
                       List{
                           //ForEach(self.itemsList.itemsList)
                        ForEach(self.listEntry.eachListItems)
                           {
                               items in
                           // RowView(entry: items, listEntry: self.$listEntry, newItem: self.$newItem)
                            RowView(entry: items)
                           }
                           .onDelete(perform: { indexSet in
                            //itemsList.itemsList.remove(atOffsets: indexSet)
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
                   }
               
    }
}

    
    
struct RowView: View{
   @State var entry: Items
   // @State var itemQty:String = "0"
   // @State var qtyType = ["KG","Grams","Pcs","Boxes","Bottles","Cans"]
   // @State var selectedPickerValue = 0
   // @Binding var newItem:String
   // @Binding var listEntry:ShoppingListEntry
    
    var body: some View {
        ScrollView{
        VStack{
            HStack(){
                Button(action: {
                    print("Checkbox clicked")
                    self.entry.itemIsShopped.toggle()
                },label: {
                    Image(systemName: entry.itemIsShopped ? "checkmark.square" : "square")
                })
               
                Text(entry.itemName).fontWeight(.bold)
                Spacer()
                Text(entry.itemQty)
                Text(entry.itemQtyType)
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
