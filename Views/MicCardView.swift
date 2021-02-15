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
   
    @State var isOkPressed:Bool = false
    @State var spokenText:String = ""
    
    var body: some View {
        
        ZStack
        {
            
            VStack{
                
                HStack{
                    Button(action: { self.presentationMode.wrappedValue.dismiss()})
                    {
                       /* Image(systemName: "xmark")
                            .clipShape(Circle())*/
                        Text("Close".uppercased()).fontWeight(.heavy).foregroundColor(.white).fixedSize()
                    }.frame(width: 80, height: 50)
                    .background(Color.blue)
                    .padding(.top,10)
                }
           
        }
            VStack{
            //Prints voice text
                Text("\(self.speechData.speech.outputText)")
                .font(.title)
                .padding(.top,20)
           
            Button(action: {
                print("Ok button pressed in mic view")
                self.isOkPressed.toggle()
                self.spokenText = self.speechData.speech.outputText //Assign spoken text to state variable
                
                if isOkPressed{
                    self.presentationMode.wrappedValue.dismiss()
                  /*  NavigationLink(destination:ShoppingListItemView(listEntry: ShoppingListEntry(listName: "Good day"), item: Items(itemName: "", itemQty: "", itemQtyType: "", itemIsShopped: false))) {}*/
                }
                
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
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        //.offset(x:0,y:300)
       
        
}
}

struct MicCardView_Previews: PreviewProvider {
    static let speechData = SpeechData()
    static var previews: some View {
        MicCardView().environmentObject(speechData)
    }
}
