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
    
    var body: some View {
        
        NavigationView
        {
            ZStack{
                Text("Hello World").padding()
           
            }.navigationBarTitle("Welcome \(userModel.currentUserName)")
            .navigationBarTitleDisplayMode(.inline)
        }
}
}


struct MyListsView_Previews: PreviewProvider {
    static var previews: some View {
        MyListsView()
    }
}
