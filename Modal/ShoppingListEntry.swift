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
    var docId : String?
    var listName : String
    var date : Date = Date()
    
}
