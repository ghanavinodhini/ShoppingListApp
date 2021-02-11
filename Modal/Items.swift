//
//  Items.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-10.
//

import Foundation
import Firebase

struct Items : Identifiable,Equatable{
    var id = UUID()
    var itemDocid:String?
    var itemName:String
    var itemQty:String
    var itemQtyType:String
    var itemIsShopped:Bool
}
