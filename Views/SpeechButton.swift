//
//  SpeechButton.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-02-13.
//

import SwiftUI
import Speech
import Foundation

struct SpeechButton: View {
    @State var animateBigCircle = false
    @State var animateSmallCircle = false
   @State var actionPop:Bool = false
    
    
    @EnvironmentObject var speechData : SpeechData
   
    var body: some View {
        VStack{
        Button(action: {
            if (self.speechData.getSpeechStatus() == "Denied - Close the App"){
                //checks status of auth if no auth pop up error
                    self.actionPop.toggle()
            }else{
                self.speechData.isRecording.toggle()
                self.speechData.isRecording ? self.speechData.startRecording() : self.speechData.stopRecording()
            }
        }) {
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
                
                Image(systemName: "mic.circle")
                    .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .background(speechData.isRecording ? Circle().foregroundColor(.red).frame(width: 70, height: 70) : Circle().foregroundColor(.blue).frame(width: 70, height: 70))
        }
        
        }.offset(y:200) //ZStack will jump to bottom
        
        // Error catch if the auth failed or denied
        }.alert(isPresented: $actionPop, content: {
            Alert(title: Text("ERROR:"), message: Text("Access Denied by User"), dismissButton: .destructive(Text("OK"),action:{}))
                })
        
    }
}

struct SpeechButton_Previews: PreviewProvider {
    static var previews: some View {
        SpeechButton().environmentObject(SpeechData())
    }
}
