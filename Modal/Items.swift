//
//  Items.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-02-04.
//

import Foundation
import Firebase

struct Items : Identifiable{
    //var id = UUID()
    var id:String?
    var itemName:String
    var itemQty:String
    var itemQtyType:String
    var itemIsShopped:Bool
}

class ItemsList : ObservableObject{
    
    @Published var itemsList = [Items]()
    
    private var db = Firestore.firestore()
    
    init(){
        
    }
    
    /*func addItems(_ itemName:String,_ itemQty:String,_ itemQtyType:String,_ itemIsShopped:Bool){
        self.itemsList.append(Items(itemName: itemName, itemQty: itemQty, itemQtyType: itemQtyType))
    }*/
    
    
}

