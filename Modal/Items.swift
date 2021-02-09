//
//  Items.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-02-04.
//

import Foundation
import Firebase

struct Items : Identifiable{
    var id = UUID()
    var itemDocid:String?
    var itemName:String
    var itemQty:String
    var itemQtyType:String
    var itemIsShopped:Bool
}

/*class ItemsModel : ObservableObject{
    
    @Published var itemModel = [Items]()
    
   @Published var shopItemEntry = ShoppingListEntry(listName: "")
    
    @Published var listDocID:String = ""
    
    private var db = Firestore.firestore()
    
    
   
    func addItems(_ itemName:String,_ itemQty:String,_ itemQtyType:String,_ itemIsShopped:Bool){
        print("Inside add items function in ItemsModel class")
        self.itemModel.append(Items(itemName: itemName, itemQty: itemQty, itemQtyType: itemQtyType, itemIsShopped: itemIsShopped))
        
        //self.shopItemEntry.eachListItems.append(Items(itemName: itemName, itemQty: itemQty, itemQtyType: itemQtyType, itemIsShopped: itemIsShopped))
        //print("Inside itemsModel itemdata: \(shopItemEntry.eachListItems)")
        
        
    }
    
    
    func fetchItemsFromDB(){
          guard let currentUser = Auth.auth().currentUser?.uid else { return }
          db.collection("Users").document(currentUser).collection("Lists").document(self.listDocID).collection("Items").getDocuments(){ (snapshot, err) in
              if let err = err{
                  print("Error getting document: \(err)")
              }else{
                print("List doc id inside itemModel: \(self.listDocID)")
                  for document in snapshot!.documents{
                      print("\(document.documentID) : \(document.data())")
                      
                      let data = document.data()
                      let itemDocId = document.documentID
                      let itemNameData = data["Item Name"] as? String ?? ""
                      let itemQtyData = data["Item Qty"] as? String ?? ""
                      let itemQtyTypeData = data["Item Qty Type"] as? String ?? ""
                      let itemIsShoppedData = data["Item IsShopped"] as? Bool ?? false
                      let ItemData = Items(id: itemDocId, itemName: itemNameData, itemQty: itemQtyData, itemQtyType: itemQtyTypeData, itemIsShopped: itemIsShoppedData)
                      
                      //self.shopItemEntry.eachListItems.append(ItemData)
                    self.itemModel.append(ItemData)
                     
                     
                  }
              }
              
          }
      }
}*/

