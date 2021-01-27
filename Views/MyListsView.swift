//
//  MyListsView.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-01-27.
//

import SwiftUI
import Firebase


struct MyListsView: View {
    @EnvironmentObject var userModel : ModelData
    @State var uname = ""
    var body: some View {
        ZStack(alignment: .top){
            VStack(spacing: 10){
                HStack{
                        Text("Logout")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color.blue)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    
                        Text("\(userModel.currentUserName)")
                            .multilineTextAlignment(.center)
                }
        }
        }
    }
    
}



struct MyListsView_Previews: PreviewProvider {
    static var previews: some View {
        MyListsView()
    }
}
