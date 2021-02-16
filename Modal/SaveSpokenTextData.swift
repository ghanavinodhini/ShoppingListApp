//
//  SaveSpokenTextData.swift
//  ShoppingList
//
//  Created by Ghanavinodhini Chandrasekaran on 2021-02-16.
//

import Foundation
import SwiftUI

struct SaveSpokenTextData : View {
    var listEntry: ShoppingListEntry
    var listDocumentID : String = ""
    var body: some View {
        
        VStack{
            Text(listEntry.docId!)
        }
    }
}
