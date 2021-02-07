//
//  ShoppingListEntry.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-01.
//

import Foundation

struct ShoppingListEntry : Identifiable {
    
    var id = UUID()
    var docId : String?
    var listName : String
    var listItem : String = ""
    var date : Date = Date()
    
    var eachListItems = [Items]()
    
}



    



