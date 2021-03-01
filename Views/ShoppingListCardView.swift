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
        ZStack(){
            Rectangle().fill(Color.blue).frame(width:330, height:40).cornerRadius(5.0).shadow(radius: 10 )
            VStack(alignment: .leading) {
                Text(entry.listName)
                HStack(){
                    Text("DueDate:")
                    Text(entry.dueDate)
                    Spacer()
                }
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListCardView(entry: ShoppingListEntry(listName: "List Name"))
    }
}
