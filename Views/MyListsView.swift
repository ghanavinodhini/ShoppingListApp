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
    @Environment(\.presentationMode) var presentationMode
    @State var uname = ""
    var body: some View {
        NavigationView
        {
            VStack
            {
              /*  Button(action:{
                    userModel.userSignOut()
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Text("LOGOUT")
                }*/
            }.navigationBarTitle("Welcome \(userModel.currentUserName)")
           // .navigationBarItems(leading: NavigationLink(destination: ContentView(),label: {
                                                           // Text("Logout") }))
        }
    }
    
}



struct MyListsView_Previews: PreviewProvider {
    static var previews: some View {
        MyListsView()
    }
}
