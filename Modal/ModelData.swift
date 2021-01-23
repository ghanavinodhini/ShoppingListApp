//
//  ModelData.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-01-23.
//

import Foundation
import Firebase


// MVVM Model...

class ModelData : ObservableObject
{
    @Published var email = ""
    @Published var password = ""
    @Published var isSignUp = false
    @Published var email_SignUp = ""
    @Published var password_SignUp = ""
    @Published var reEnterPassword = ""
    @Published var isSuccessful = false
   
    
    // Error Alerts...
    
    @Published var alert = false
    @Published var alertMsg = ""
    
   
    
    // Login...
    
    func login()
    {
        
        // checking all fields are inputted correctly...
        
        if email == "" || password == ""{
            
            self.alertMsg = "Fill the contents properly !!!"
            self.alert.toggle()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            
            if err != nil{
                
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }else{
              self.alertMsg = "Login Success"
              self.alert.toggle()
            
            }
        }
    }
    
    // SignUp..
    
    func signUp()
    {
        
        // checking....
        
        if email_SignUp == "" || password_SignUp == "" || reEnterPassword == ""
        {
            self.alertMsg = "Fill all data proprely!!!"
            self.alert.toggle()
            return
        }
        
        if password_SignUp != reEnterPassword
        {
            self.alertMsg = "Password Mismatch !!!"
            self.alert.toggle()
            return
        }
        
        Auth.auth().createUser(withEmail: email_SignUp, password: password_SignUp) { (result, err) in
            if err != nil{
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }else{
              self.alertMsg = "SignUp Successful"
              self.alert.toggle()
            }
        }
    }
}
