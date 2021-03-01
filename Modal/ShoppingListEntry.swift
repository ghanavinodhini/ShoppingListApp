//
//  ShoppingListEntry.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-01.
//

import Foundation

struct ShoppingListEntry : Identifiable  {
    
    var id = UUID()
    var listDocId : String?
    var listName : String
    var date : Date = Date()
    var eachListItems = [Items]()
    var dueDate: String = ""
}
