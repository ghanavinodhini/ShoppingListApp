//
//  EditShoppingListAlertView.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-08.
//

import Foundation
import SwiftUI
struct EditShoppingListAlertView: View {
    
    let screenSize = UIScreen.main.bounds
    var title: String = ""
    @Binding var isShown: Bool
    @Binding var listName: String
    var onAdd: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    
    
    var body: some View {
    
        VStack(alignment: .leading) {
          
            Text(title)
                .font(.headline)
            TextField("", text: $listName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack() {
                Button("Cancel") {
                    self.isShown = false
                    self.onCancel()
                }.foregroundColor(.red)
                Button("Update") {
                    self.isShown = false
                    self.onAdd(self.listName)
                }
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.2)
        .background(Color(#colorLiteral(red: 0.9268686175, green: 0.9416290522, blue: 0.9456014037, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        
        .shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 6, x: -9, y: -9)

    }
}

struct EditShoppingListAlertView_Previews: PreviewProvider {
    static var previews: some View {
       EditShoppingListAlertView(title: "Add Item", isShown: .constant(true), listName: .constant(""))
    }
}