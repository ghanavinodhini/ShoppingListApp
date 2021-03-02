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
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors:[Color.white,Color(.systemIndigo)]),startPoint: .topLeading,endPoint: .bottomTrailing))
                .frame(width:330, height:40).cornerRadius(5.0).shadow(radius: 10 )
            VStack(alignment: .leading) {
                Text(entry.listName).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).font(.callout)
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
