//
//  MicCardView.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-02-12.
//

import SwiftUI

struct MicCardView: View {
    
    @EnvironmentObject var speechData : SpeechData
    @Environment(\.presentationMode) var presentationMode
   
    var body: some View {
        
        ZStack
        {
            VStack(alignment: .trailing){
            Button(action: { self.presentationMode.wrappedValue.dismiss()})
            {
               /* Image(systemName: "xmark")
                    .clipShape(Circle())*/
                Text("Close".uppercased()).fontWeight(.heavy).foregroundColor(.white).fixedSize()
            }.frame(width: 80, height: 50)
            .background(Color.blue)
            .padding(.top,10)
        }
            VStack{
            //Prints voice text
            Text("\(self.speechData.outputText)")
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
            
            //Gets speech button
            self.speechData.getButton()
        }
        }
        
}
}

struct MicCardView_Previews: PreviewProvider {
    static let speechData = SpeechData()
    static var previews: some View {
        MicCardView().environmentObject(speechData)
    }
}
