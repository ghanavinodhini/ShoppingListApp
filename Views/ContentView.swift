//
//  ContentView.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-01-22.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
   // @State var userModel = ModelData()
    @EnvironmentObject var userModel : ModelData
    var body: some View {
        
        LoginView(userModel: userModel)
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Login View
struct LoginView : View {
      
      @ObservedObject var userModel : ModelData
      
      var body: some View{
          
          ZStack{
              VStack{
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
                     
                  
                VStack(spacing:10){
                          Text("Shopping List")
                              .font(.system(size: 35, weight: .heavy))
                              .foregroundColor(.blue)
                  }.padding(.top)
                  
                  VStack(spacing: 20)
                  {
                    HStack(spacing:15){
                        Image(systemName: "envelope.fill")
                        TextField("Enter Email", text:$userModel.email)
                    }
                    Divider().background(Color.white.opacity(0.5))
                    HStack(spacing: 15){
                        Image(systemName: "eye.slash.fill")
                        TextField("Enter Password", text:$userModel.password)
                    }
                    Divider().background(Color.white.opacity(0.5))
                    
                  }.padding()
                
                    //Forgot Password action
                    Button(action: userModel.resetPassword) {
                        Text("Forgot Password?")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(Color.blue)
                    }
                    Divider().background(Color.white.opacity(0.5))
                    .padding(.top,10)
                  
                //Login Button
                  Button(action: userModel.login)
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
                /* .alert(isPresented: $userModel.alert, content: {
                       
                       Alert(title: Text("Message"), message: Text(userModel.alertMsg), dismissButton: .destructive(Text("Ok"), action: {
                 
                 if userModel.alertMsg == "Login Success"
                 {
                    print("Navigate to home screen")
                    userModel.isLogin.toggle()
                 }
                   }))
                 })*/
               // .sheet(isPresented: $userModel.isLogin) {
                     // MyListsView()
             // }
                
                
                  HStack(spacing: 10){
                      Button(action: {userModel.isSignUp.toggle()})
                      {
                          Text("Sign Up")
                              .fontWeight(.bold)
                              .foregroundColor(.blue)
                      }
                  }.padding(.top,25)
                    Spacer()
                  
              }
          }.sheet(isPresented: $userModel.isSignUp)
                {
                    SignUpView(userModel: userModel)
                }
        VStack{
           /* if (userModel.isLogin){
               MyListsView()
            }*/
        }.fullScreenCover(isPresented: $userModel.isLogin)
        {
            MyListsView()
        }
          // Alerts for Login button validate fields
          .alert(isPresented: $userModel.alert, content: {
              
              Alert(title: Text("Message"), message: Text(userModel.alertMsg), dismissButton: .destructive(Text("Ok")))
          })
      }
}


  
//SignUp View
struct SignUpView : View {
    
    @ObservedObject var userModel : ModelData
    @Environment(\.presentationMode) var presentationMode
    var body: some View{
        
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top), content: {
            
            VStack{
                
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
                }.padding(.top)
                
                VStack(spacing: 5){
                    HStack{
                        Text("New Account")
                            .font(.system(size: 35, weight: .heavy))
                            .foregroundColor(.blue)
                    }
                }.padding(.top)
                
                VStack(spacing: 20){
                    HStack(spacing: 15){
                        Image(systemName: "person.fill")
                        TextField("Enter Your Name",text:$userModel.userName_SignUp)
                    }
                    Divider().background(Color.white.opacity(0.5))
                    HStack(spacing: 15){
                        Image(systemName: "envelope.fill")
                        TextField("Enter Email",text:$userModel.email_SignUp)
                    }
                    Divider().background(Color.white.opacity(0.5))
                    HStack(spacing: 15){
                        Image(systemName: "eye.slash.fill")
                        TextField("Enter Password",text:$userModel.password_SignUp)
                    }
                    Divider().background(Color.white.opacity(0.5))
                    HStack(spacing: 15){
                        Image(systemName: "eye.slash.fill")
                        TextField("Re-Enter Password",text:$userModel.reEnterPassword)
                    }
                    Divider().background(Color.white.opacity(0.5))
                 
                }
                .padding()
               
                //SignUp button
                Button(action: userModel.signUp) {
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
            //Toggle isSignup on click,  //Display close button in signup view
            Button(action: {userModel.isSignUp.toggle()}){
                Image(systemName: "xmark")
                    .padding()
                    .clipShape(Circle())
            }
            .padding(.trailing)
            .padding(.top,10)
        })
    
        // Alerts Signup success
        .alert(isPresented: $userModel.alert, content: {
            Alert(title: Text("Message"), message: Text(userModel.alertMsg), dismissButton: .destructive(Text("Ok"), action: {
                 
              if userModel.alertMsg == "SignUp Successful"
              {
                    userModel.userName_SignUp = ""
                    userModel.email_SignUp = ""
                    userModel.password_SignUp = ""
                    userModel.reEnterPassword = ""
                self.presentationMode.wrappedValue.dismiss()
                }
            }))
        })
    }
}


