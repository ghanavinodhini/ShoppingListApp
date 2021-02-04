//
//  ShoppingListCardView.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-03.
//

import SwiftUI

struct ShoppingListCardView: View {
    var entry: ShoppingListEntry
    var body: some View {
        ZStack{
            Rectangle().fill(Color.blue).frame(width:350, height:25).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/).shadow(radius: 10 )
            VStack{
                Text(entry.listName)
            }
            
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListCardView(entry: ShoppingListEntry(listName: "Bra dag", listItem: ""))
    }
}