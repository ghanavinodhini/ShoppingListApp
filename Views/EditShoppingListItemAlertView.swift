//
//  EditShoppingListItemAlertView.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-13.
//

import Foundation
import SwiftUI

struct EditShoppingListItemAlertView: View {
    
    let screenSize = UIScreen.main.bounds
    var title: String = ""
    @Binding var isShown: Bool
    @Binding var shoppingListItem: String
    var onAdd: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    @Binding var itemQty:String 
    //@State var itemQtyType = ["KG","Grams","Pcs","Boxes","Packets","Bunches","Bottles","Cans"]
//    @State var selectedPickerValue = 0
    
    var body: some View {
        
        VStack(alignment: .center) {
            Text(title)
                .font(.headline)
            TextField("", text: $shoppingListItem)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack{
            Text("Qty")
            TextField("Qty", text:self.$itemQty)
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
                .fixedSize()
                Spacer()
                /*Picker(selection: $selectedPickerValue, label: Text("Choose Value")) {
                                               ForEach(0 ..< itemQtyType.count) {
                                                  Text(self.itemQtyType[$0])
                                               }
                                   }.frame(height: 5)
                                   .frame(width: 5)
                                   .scaledToFit()
                                   .scaleEffect(CGSize(width: 0.5, height: 0.8))
                                   .foregroundColor(.white)
                                   .pickerStyle(WheelPickerStyle())
                                   .padding()*/
            }
            HStack(alignment: .center) {
                Button("Cancel") {
                    self.isShown = false
                    self.onCancel()
                }.foregroundColor(.red)
                .frame(width: 55, height: 50, alignment: .center)
                Button("Update") {
                    self.isShown = false
                    self.onAdd(self.shoppingListItem)
                    self.onAdd(self.itemQty)
               //     self.onAdd(self.itemQtyType[selectedPickerValue])
                    self.shoppingListItem = ""
                    self.itemQty = ""
                }
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.3)
        .background(Color(#colorLiteral(red: 0.9268686175, green: 0.9416290522, blue: 0.9456014037, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        
        .shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 3, x: -9, y: -9)
        
    }
}
struct EditShoppingListItemAlertView_Previews: PreviewProvider {
    static var previews: some View {
        EditShoppingListItemAlertView(title: "Add Item", isShown: .constant(true), shoppingListItem: .constant(""), itemQty: .constant(""))
    }
}
