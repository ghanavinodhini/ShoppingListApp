//
//  ShoppingList.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-01.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class ShoppingList : ObservableObject {
    
    @Published var entries = [ShoppingListEntry]()
    @Published var itemModel = [Items]()
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
                let docID = queryDocumentSnapshot.documentID
                print(docID)
                return ShoppingListEntry(docId: docID, listName: listName)
                
            }
        }
    }
}
