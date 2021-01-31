//
//  SlidingMenuView.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-01-28.
//

import SwiftUI

struct MenuButton:Identifiable
{
    var id = UUID()
    var text:String
    var sfsymbol:String
    var action:() -> Void
}
struct SlidingMenuView: View {
    
    var buttons :[MenuButton]
    var body: some View {
        HStack {
            VStack {
                Spacer().frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                ForEach(buttons, id: \.id){thisButton in Button(action: {thisButton.action()}){
                    HStack{
                        Image(systemName: thisButton.sfsymbol)
                        Text(thisButton.text)
                    }.padding().foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }}
                //Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                Spacer()
            }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            Spacer()
        }
    }
}

/*struct SlidingMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SlidingMenuView()
    }
}*/
