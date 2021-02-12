//
//  MicCardView.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-02-12.
//

import SwiftUI

struct MicCardView: View {
    @State var animateBigCircle = false
    @State var animateSmallCircle = false
    var body: some View {
        
        VStack
        {
            Button(action: {})
            {
                Image(systemName: "xmark")
                    .clipShape(Circle())
            }.frame(width: 30, height: 30, alignment: .topTrailing)
            .padding(.top,10)
            
            
            Text("Spoken word")
                .font(.title)
                .padding(.top,20)
           
            Button(action: {
                print("Ok button pressed in mic view")
            }) {
                Text("Ok".uppercased())
                    .fontWeight(.heavy)
                    .frame(width:50,height:50)
                    .foregroundColor(.white)
                    .accentColor(Color.white)
                
            }.padding(.vertical,20)
            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
            .cornerRadius(10)
        
            
        ZStack
        {
            Circle() //Big Circle
        .stroke()
        .frame(width: 350, height: 350, alignment: .bottom)
        .foregroundColor(.gray)
        .scaleEffect(animateBigCircle ? 1 : 0.3)
        .opacity(animateSmallCircle ? 0 : 1)
        .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false))
        .onAppear(){
            self.animateBigCircle.toggle()
                }
            
           Circle() //Middle Circle
            .foregroundColor(.primary)
            .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .scaleEffect(animateSmallCircle ? 0.9 : 1.1)
            .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: false))
            .onAppear(){
                self.animateSmallCircle.toggle()
                    }
            
            Circle() //Small Circle
                .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            
            Image(systemName: "mic")
                .frame(width: 20, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
            
        }.offset(y:250) //ZStack will jump to bottom
    }
        
    
}
}

struct MicCardView_Previews: PreviewProvider {
    static var previews: some View {
        MicCardView()
    }
}
