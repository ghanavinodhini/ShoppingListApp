//
//  SlidingMenuView.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-01-28.
//

import SwiftUI

/*struct MenuButton:Identifiable
{
    var id = UUID()
    var text:String
    var sfsymbol:String
    var action:() -> Void
}*/
struct SlidingMenuView: View {
    @EnvironmentObject var userModel : ModelData
    
    var body: some View {
        
        VStack()
        {
            NavigationView
            {
            HStack
            {
                Button(action: userModel.userSignOut) {
                    Image(systemName: "arrow.left.square").foregroundColor(.blue).imageScale(.large)
                    Text("Logout").foregroundColor(.blue).font(.headline)
                    Spacer()
                    if !userModel.isLogin
                    {
                        NavigationLink(destination: ContentView()){}
                            
                    }
                
                }
                
            }.padding(.top,10)
                Spacer()
        }
    }.padding()
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(Color.gray)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        Spacer()
    }
}

struct SlidingMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SlidingMenuView()
    }
}
