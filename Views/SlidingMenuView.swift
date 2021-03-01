//
//  SlidingMenuView.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-01-28.
//

import SwiftUI

struct SlidingMenuView: View {
    // @EnvironmentObject var userModel : ModelData
    @ObservedObject var userModel: UserModelData
    var body: some View {
        
        VStack()
        {
            
            Text("Welcome \(userModel.currentUserName)")
                .font(.headline)
                .padding(.top,100)
            
            // NavigationView
            // {
            HStack
            {
                Button(action: userModel.userSignOut) {
                    Image(systemName: "arrow.left.square").foregroundColor(.black).imageScale(.large)
                    Text("Logout").foregroundColor(.black).font(.headline)
                    
                    if !userModel.isLogin
                    {
                        NavigationLink(destination: AuthenticationView()){}
                        
                    }
                    
                }
                
                
            }.padding(.top,80)
            Spacer()
            // }
        }.padding()
        .frame(maxWidth: .infinity,alignment: .leading)
        .background(Color.gray)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
    }
}

/*struct SlidingMenuView_Previews: PreviewProvider {
 static var previews: some View {
 SlidingMenuView()
 }
 }*/
