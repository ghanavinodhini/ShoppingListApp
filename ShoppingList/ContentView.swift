//
//  ContentView.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-01-22.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @StateObject var model = ModelData()
    
    var body: some View {
       
        LoginView(model: model)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct LoginView : View {
      
      @ObservedObject var model : ModelData
      
      var body: some View{
          
          ZStack{
              
              VStack{
                  
                  Spacer()
                  
                  ZStack{
                      //For smaller Devices
                      if UIScreen.main.bounds.height < 750
                      {
                          Image("logo")
                              .resizable()
                              .frame(width: 100, height: 100)
                      }
                      else{
                          Image("logo")
                            .resizable()
                            .frame(width: 150, height: 150)
                            }
                  }
                      .padding(.horizontal)
                      .padding(.vertical,20)
                      //.padding(.top)
                  
                  VStack(spacing: 5){
                      HStack(spacing: 10){
                          Text("Shopping List")
                              .font(.system(size: 35, weight: .heavy))
                              .foregroundColor(.blue)
                      }
                  }.padding(.top)
                  
                  VStack(spacing: 20)
                  {
                    TextField("Enter Email", text:$model.email)
                    TextField("Enter Password", text:$model.password)
                  }.padding()
                  
                  Button(action: model.login)
                  {
                      Text("LOGIN")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 30)
                            .background(Color.blue)
                            .clipShape(Capsule())
                  }
                  .padding(.top,20)
                  //Display Next List screen if Login success
                  //.sheet(isPresented: $model.isSuccessful) {
                     // ListContentView()
                  
                  HStack(spacing: 10){
                      
                      Button(action: {model.isSignUp.toggle()})
                      {
                          Text("Sign Up")
                              .fontWeight(.bold)
                              .foregroundColor(.blue)
                      }
                  }.padding(.top,25)
                    Spacer()
                  
              }
          }.fullScreenCover(isPresented: $model.isSignUp)
                {
                    SignUpView(model: model)
                }
          // Alerts...
          .alert(isPresented: $model.alert, content: {
              
              Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("Ok")))
          })
      }
}


  

struct SignUpView : View {
    
    @ObservedObject var model : ModelData
    
    var body: some View{
        
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top), content: {
            
            VStack{
                
                Spacer(minLength: 0)
                
                ZStack{
                    //For small devices
                    if UIScreen.main.bounds.height < 750{
                        
                        Image("logo")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    else{
                        Image("logo")
                            .resizable()
                            .frame(width: 150, height: 150)
                    }
                }
                    .padding(.horizontal)
                    .padding(.vertical,20)
                   
                    .cornerRadius(30)
                    .padding(.top)
                
                VStack(spacing: 5){
                    
                    HStack{
                        
                        Text("New Account")
                            .font(.system(size: 35, weight: .heavy))
                            .foregroundColor(.blue)
                      
                    }
                  
                }
                .padding(.top)
                
                VStack(spacing: 20){
                  
                  TextField("Enter Email",text:$model.email_SignUp)
                  TextField("Enter Password",text:$model.password_SignUp)
                  TextField ("Re-Enter Password",text:$model.reEnterPassword)
                }
                .padding()
                
                Button(action: model.signUp) {
                    
                    Text("SIGNUP")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color.blue)
                        .clipShape(Capsule())
                }.padding(.vertical,20)
                    Spacer()
            }
            
            Button(action: {model.isSignUp.toggle()}) {
                
                Image(systemName: "xmark")
                    .padding()
                    .clipShape(Circle())
            }
            .padding(.trailing)
            .padding(.top,10)
            
       
        })
    
        // Alerts...
        .alert(isPresented: $model.alert, content: {
            
            Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("Ok"), action: {
                 
              
              if model.alertMsg == "SignUp Successful"
              {
                    
                   // model.isSignUp.toggle()
                    model.email_SignUp = ""
                    model.password_SignUp = ""
                    model.reEnterPassword = ""
                }
                
            }))
        })
    }
}


