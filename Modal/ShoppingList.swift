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
     var docID : String = ""
    private var db = Firestore.firestore()
     private var listName: String = ""
    var itemdocID : String = ""
    init(){
     fetchListFromDatabase()
        //fetchItemDocidFromDB()
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
                self.listName = data["listName"] as? String ?? ""
                self.docID = queryDocumentSnapshot.documentID
               // print(self.docID)
                
                return ShoppingListEntry(docId: self.docID, listName: self.listName)
                
            }
            self.fetchItemDocidFromDB()
        }
    }
    func fetchItemDocidFromDB() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").document(docID).collection("Items").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.entries = documents.map { (queryDocumentSnapshot) -> ShoppingListEntry in
                let data = queryDocumentSnapshot.data()
                self.itemdocID = queryDocumentSnapshot.documentID
                print(self.docID)
                print(self.itemdocID)
                print(self.listName)
                return ShoppingListEntry( docId: self.docID, itemDocId: self.itemdocID, listName: self.listName)
            }
        }
    }
}
