//
//  CurrentUser.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-01-27.
//

import Foundation
import Firebase

class CurrentUser{
    
    var currentUserName = ""
    
    func getCurrentUserInfo(){
         let db = Firestore.firestore()
         guard let currentUser = Auth.auth().currentUser?.uid else { return }
         db.collection("Users").document(currentUser)
             .addSnapshotListener{(snap,err) in
             if err != nil{
                 print("Error fetching data from firebase")
                 return
             }
                 if let data = snap?.data(){
                    self.currentUserName = (data["UserName"] as? String)!
                     print("Current User Name: \(self.currentUserName)")
                    
                 }
         }
        
     }
}
