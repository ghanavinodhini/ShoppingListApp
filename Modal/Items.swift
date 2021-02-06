//
//  Items.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-02-04.
//

import Foundation

struct Items : Identifiable{
    var id = UUID()
    var itemName:String
    var itemQty:String
    var itemQtyType:String
    var itemIsShopped:Bool = false
}

class ItemsList : ObservableObject{
    
    @Published var itemsList = [Items]()
    
    init(){
       // addItems()
    }
}

