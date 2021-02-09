//
//  ShoppingListEntry.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-01.
//

import Foundation
import FirebaseFirestoreSwift
struct ShoppingListEntry : Codable, Identifiable  {
    
    var id = UUID()
    @DocumentID var docId : String?
    var listName : String
    var listItem : String = ""
    var date : Date = Date()
    
}
