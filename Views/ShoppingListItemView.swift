//
//  ShoppingListItemView.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-02.
//

import SwiftUI


struct ShoppingListItemView : View {
    @ObservedObject var list = ShoppingListName()
    @ObservedObject var itemsList = ItemsList()
      @State var newItem:String = ""
      @State var showErrorMessage = false
      //Text field for adding new item
      var itemTextBar : some View{
          HStack{
            TextField("Enter New Item",text:self.$newItem)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(Color.black)
              Button(action: self.addNewItem, label: {
                  Text("ADD")
                  
              })
              //Alert if no values entered in textfield
          }.alert(isPresented: self.$showErrorMessage) {
              Alert(title: Text("Error"), message: Text("Please enter some Item!"), dismissButton: .default(Text("OK")))
          }
      }
      
      func addNewItem()
      {
          if self.newItem.isEmpty
          {
              self.showErrorMessage.toggle()
          }else{
              self.showErrorMessage = false
            itemsList.itemsList.append(Items(itemName: newItem, itemQty: "0"))
          self.newItem = ""
          }
      }

    
    var body: some View {
                   VStack{
                       itemTextBar.padding()
                      // List(self.itemsList.itemsList){ items in
                       List{
                           ForEach(self.itemsList.itemsList){
                               items in
                               RowView(entry: items)
                           }
                           .onDelete(perform: { indexSet in
                            itemsList.itemsList.remove(atOffsets: indexSet)
                           })
                           .listRowBackground(Color(.white).clipped().cornerRadius(10))
                       }.navigationBarTitle("List Items")
                       .navigationBarItems(trailing: EditButton())
                   }
               }
           }

    
    
struct RowView: View{
    var entry: Items
    @State var itemQty:String = "0"
    var qtyType = ["KG","Grams","Pcs","Boxes","Bottles","Cans"]
    @State var selectedPickerValue = 0
    
    var body: some View {
        ScrollView{
        VStack{
            HStack(){
                Button(action: {
                    print("Checkbox")
                },label: {
                    Image(systemName: entry.itemShopped ? "checkmark.square" : "square")
                })
               
           // }
           // HStack(alignment: .center)
           // {
                Text(entry.itemName).fontWeight(.bold)
                Spacer()
            }
            
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
                
                //Text("You selected: \(qtyType[selectedPickerValue])")
            }.padding()
            
            }
        }
        
}
}


struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListItemView()
    }
}
