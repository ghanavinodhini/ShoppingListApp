//
//  ModelData.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-01-23.
//

import Foundation
import Firebase


// MVVM Model

class ModelData : ObservableObject
{
    @Published var userName_SignUp = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isSignUp = false
    @Published var email_SignUp = ""
    @Published var password_SignUp = ""
    @Published var reEnterPassword = ""
   
    // Error Alerts
    @Published var alert = false
    @Published var alertMsg = ""
    
   
    
    // Login
    func login()
    {
        // checking all fields are entered
        if email == "" || password == ""
        {
            self.alertMsg = "Please Fill All Data"
            self.alert.toggle()
            return
        }
        //Login useraccount
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
    
    // SignUp
    func signUp()
    {
        
        // checking all fields have values
        if userName_SignUp == "" || email_SignUp == "" || password_SignUp == "" || reEnterPassword == ""
        {
            self.alertMsg = "Please Enter All Data"
            self.alert.toggle()
            return
        }
        
        if password_SignUp != reEnterPassword
        {
            self.alertMsg = "Password Mismatch"
            self.alert.toggle()
            return
        }
        //Create New User in Firebase
        Auth.auth().createUser(withEmail: email_SignUp, password: password_SignUp) { (result, err) in
            if err != nil{
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }else{
              self.alertMsg = "SignUp Successful"
              self.alert.toggle()
                //Calling upload function to store user data
                self.uploadUserInfo(userName:self.userName_SignUp,userEmail:self.email_SignUp)
        }
        }
    }
    
    //Store user info in Firestore
    func uploadUserInfo(userName:String,userEmail:String)
    {
        print("Inside upload user info")
        let db = Firestore.firestore()
        db.collection("Users").document().setData(["UserName":userName,"UserEmail":userEmail])
    }
    
    //Reset Password
    func resetPassword()
    {
        let resetAlert = UIAlertController(title: "Reset Password", message: "Enter Valid E-Mail ID To Reset Your Password", preferredStyle: .alert)
    
        resetAlert.addTextField { (password) in
        password.placeholder = "Valid Email Address"
        }
        
        //Closure for proceeding password reset alert
        let resetOk = UIAlertAction(title: "Reset", style: .default) { (_) in
            
            // Sending Password Link...
            if resetAlert.textFields![0].text! != ""
            {
                let resetEmail = resetAlert.textFields?[0].text
                print("Reset Email entered: \(String(describing: resetEmail))")
                //Auth.auth().sendPasswordReset(withEmail: resetAlert.textFields![0].text!) { (err) in
                Auth.auth().sendPasswordReset(withEmail: String(resetEmail ?? "")) { (err) in
                    if err != nil
                    {
                        self.alertMsg = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    // Alerting User for password reset link
                    self.alertMsg = "Password Reset Link Has Been Sent"
                    self.alert.toggle()
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        resetAlert.addAction(cancel)
        resetAlert.addAction(resetOk)
        
        // Presenting alert window
        UIApplication.shared.windows.first?.rootViewController?.present(resetAlert, animated: true)
    }
}
