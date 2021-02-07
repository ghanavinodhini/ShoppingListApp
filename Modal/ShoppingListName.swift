//
//  ShoppingListName.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-01.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ShoppingListName : ObservableObject {
    
    @Published var entries = [ShoppingListEntry]()
    
    private var db = Firestore.firestore()
    
    init(){
        fetchListFromDatabase()
    }
    
    func fetchListFromDatabase() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.entries = documents.map { (queryDocumentSnapshot) -> ShoppingListEntry in
                let data = queryDocumentSnapshot.data()
                let listName = data["listName"] as? String ?? ""
                let docId = queryDocumentSnapshot.documentID
                return ShoppingListEntry(docId: docId, listName: listName)
                
            }
        }
    }
    
}
