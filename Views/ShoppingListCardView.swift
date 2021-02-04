//
//  ShoppingListCardView.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-03.
//

import Foundation
import SwiftUI

struct ShoppingListCardView: View {
    var entry: ShoppingListEntry
    var body: some View {
        ZStack{
            Rectangle().fill(Color.red).frame(width:50, height:50)
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
