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
    @Binding var shoppingListEditItem: String
    var onAdd: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    @Binding var itemQty:String 
    @Binding var itemQtyType:String
    
    var body: some View {
        
        VStack(alignment: .center) {
            Text(title)
                .font(.headline)
            TextField("", text: $shoppingListEditItem)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            VStack{
                HStack{
                    Text("Qty")
                    TextField("Qty", text:self.$itemQty)
                        .keyboardType(.numbersAndPunctuation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black)
                        .fixedSize()
                    Spacer()
                    Text("Type")
                        .font(.subheadline)
                    TextField("QtyType", text:self.$itemQtyType)
                        .keyboardType(.numbersAndPunctuation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black)
                        .fixedSize()
                }
                Divider()
                HStack(alignment: .center) {
                    Button("Cancel") {
                        self.isShown = false
                        self.onCancel()
                    }.foregroundColor(.red)
                    .frame(width: 55, height: 50, alignment: .center)
                    Divider()
                    Button("Update") {
                        self.isShown = false
                        self.onAdd(self.shoppingListEditItem)
                        self.onAdd(self.itemQty)
                        self.onAdd(self.itemQtyType)
                        self.shoppingListEditItem = ""
                        self.itemQty = ""
                        self.itemQtyType = ""
                    }.disabled(shoppingListEditItem.isEmpty || itemQty.isEmpty || itemQtyType.isEmpty)
                }
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.25)
        .background(Color(#colorLiteral(red: 0.9268686175, green: 0.9416290522, blue: 0.9456014037, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        
        .shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 3, x: -9, y: -9)
        
    }
}
struct EditShoppingListItemAlertView_Previews: PreviewProvider {
    static var previews: some View {
        EditShoppingListItemAlertView(title: "Add Item", isShown: .constant(true), shoppingListEditItem: .constant(""), itemQty: .constant(""), itemQtyType: .constant(""))
    }
}
