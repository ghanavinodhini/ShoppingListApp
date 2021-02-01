//
//  MyListsView.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-01-27.
//

import SwiftUI
import Firebase


struct MyListsView: View {
    //@EnvironmentObject var userModel : ModelData
    @ObservedObject var userModel : ModelData
   // @Environment(\.presentationMode) var presentationMode
    
    @State var showMenu = false
    var body: some View {
        
         NavigationView {
            GeometryReader{ geometry in
                ZStack(alignment: .leading)
                {
                    MainView(showMenu: self.$showMenu)
                        .frame(width: geometry.size.width,height: geometry.size.height)
                        .offset(x: self.showMenu ? geometry.size.width/2:0)
                        .disabled(self.showMenu ? true:false)
                    
                    if self.showMenu{
                        SlidingMenuView(userModel: userModel)
                            .frame(width: geometry.size.width/2)
                            .transition(.move(edge: .leading))
                        
                    }
                }
            }.navigationBarTitle("Shopping List", displayMode: .inline)
            .navigationBarItems(leading: (
                Button(action: {
                    withAnimation{
                        self.showMenu.toggle()
                    }
                }){
                    Image(systemName: "line.horizontal.3").imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                }
            ))
        }
        
        /*NavigationView
        {
            ZStack{
                Text("Hello World").padding()
           
            }.navigationBarTitle("Welcome \(userModel.currentUserName)")
            .navigationBarTitleDisplayMode(.inline)
        }*/
}
}

struct MainView : View
{
    @Binding var showMenu:Bool
    var body: some View
    {
        Button(action: {
            withAnimation{
            self.showMenu = true
            }
        }){
            Text("Hello world")
        }
    }
}


struct MyListsView_Previews: PreviewProvider {
    static var previews: some View {
        MyListsView(userModel: ModelData())
    }
}
