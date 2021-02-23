//
//  ShoppingListItemView.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-02.
//

import SwiftUI
import Firebase


struct ShoppingListItemView : View {
    
    @EnvironmentObject var userModel : UserModelData
    @State var listEntry : ShoppingListEntry
    
    @State var item : Items
    @State var newItem:String = ""
    @State var showErrorMessage = false
    @State var newItemQty:String = "0"
    @State var newQtyType = ["KG","Grams","Pcs","Boxes","Packets","Bunches","Bottles","Cans","Rolls"]
    @State var selectedPickerValue = 0
    @State var newItemIsShopped:Bool = false
    @State var isItemAddCardShown:Bool = false
    @State var isAddCartIconClicked:Bool = false
    @State var isAddItemMode:Bool = false

    @State var itemDocId : String
    @State var ediShoppingListItemAlert = false
    @State var itemName : String = ""
    @State var itemQtyType:String = ""
    
    @State var isMicCardViewShown:Bool = false
    var speechData = SpeechData()
    
    //For autocomplete txtfield
    var autoCompleteData : [String]
    @State var isSearchRowSelected:Bool = false
    
    var db = Firestore.firestore()
    
    //Text field for adding new item
      var newItemAddCard : some View{
       
        VStack{
            ZStack(){
            Rectangle().foregroundColor(Color(.white))
                .cornerRadius(5)
                .frame(width: UIScreen.main.bounds.width - 60,height:40)
            HStack{
                TextField("Enter New Item",text:self.$newItem, onEditingChanged: { isEditing in
                            self.isSearchRowSelected = false
                    
                }).padding().foregroundColor(.black)
                
                //AutoSearchsuggestion List
                if self.newItem != ""
                {
                    List(self.autoCompleteData.filter{$0.lowercased().contains(self.newItem.lowercased())},id: \.self){ selectedItem in
                        Text(selectedItem)
                            .onTapGesture(perform: {
                            print("selected value: \(selectedItem)")
                            self.newItem = selectedItem
                            self.isSearchRowSelected = true
                            print("SearchText value: \(self.newItem)")
                        }).foregroundColor(.red)
                   
                }.frame(height: 90)
                    .opacity(self.isSearchRowSelected ? 0 : 1) //Hide & Show autoSearchlist on item selected
                
                }
                
                
            Spacer()
            
                Button(action: {
                    print("mic button pressed")
                    withAnimation{
                        self.isMicCardViewShown.toggle() //toggle miccardview shown flag
                    }
                })
                 {
                Image(systemName: "mic")
                    .font(Font.system(size:15).weight(.bold)).padding()
                    .frame(width:30,height:30)
                    .foregroundColor(.white)
                    .background(Color(.systemIndigo))
                    .cornerRadius(5)
                }
                }.padding(.horizontal)
            }
            VStack{
                HStack{
                    Text("Qty:")
                    TextField("Qty", text:self.$newItemQty, onEditingChanged: { isEditing in
                                self.isSearchRowSelected = true
                    })
                        .keyboardType(.numbersAndPunctuation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(.black)
                        .fixedSize()
                Spacer()
                
                    Picker(selection: $selectedPickerValue, label: Text("Choose Value")) {
                                ForEach(0 ..< newQtyType.count) {
                                   Text(self.newQtyType[$0])
                                }
                    }.frame(height: 50)
                    .frame(width: 40)
                    .scaledToFit()
                    .scaleEffect(CGSize(width: 0.8, height: 0.8))
                    .foregroundColor(.white)
                    .pickerStyle(WheelPickerStyle())
                    .padding()
                }.padding(.leading, 60)
                HStack{
                Button(action: self.addNewItem, label: {
                     Text("ADD")
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .font(.title2)
                        //.padding(.bottom,50)
                        .cornerRadius(5)
                 })
                    Button(action: {
                        self.isItemAddCardShown.toggle()
                        self.isAddCartIconClicked.toggle()
                        self.isAddItemMode.toggle()
                        self.isSearchRowSelected.toggle()
                    }) {
                         Text("Close")
                            .background(Color(.systemBlue))
                            .foregroundColor(.white)
                            .font(.title2)
                          //  .padding(.bottom,50)
                            .cornerRadius(5)
                     }
                }
            }.padding()
              
        }.frame(width:  UIScreen.main.bounds.width - 32, height: 230, alignment: .top)
        .background(Color(.systemGreen))
        .cornerRadius(10)
        .shadow(radius:8)
        
        //Alert if no values entered in textfield
        .alert(isPresented: self.$showErrorMessage)
        {
            Alert(title: Text("Error"), message: Text("Please input some Item!"), dismissButton: .default(Text("OK")))
        }
    }
    
   
    var body: some View
    {
        //Displaying MicCardView on Mic button click
        if self.isMicCardViewShown{
            VStack{}.fullScreenCover(isPresented: $isMicCardViewShown)
            {
                //MicCardView().environmentObject(SpeechData())
                MicView(listEntry: listEntry).environmentObject(SpeechData())
            }
        }
      
        //Displaying Card View if add cart clicked
       
        if self.isItemAddCardShown
        {
                newItemAddCard.padding()
           
        }
            //List UI
        ZStack{
            VStack(alignment: .leading)
            {
                List
                    {
                        ForEach(self.listEntry.eachListItems)
                           {
                               items in
                            {
                            ItemRowView(entry: items, listEntry: $listEntry, isAddCartIconClicked: $isAddCartIconClicked)
                           
                    }()
                        .contextMenu{
                            Button(action: {
                                itemDocId = items.itemDocid!
                                self.ediShoppingListItemAlert = true
                            }) {
                                Text("Edit")
                                
                            }
                            Button(action: {
                            }) {
                                Text("Cancel")
                            }
                        }
                    }.onDelete(perform: self.deleteItem)
                    .id(UUID())

                    }.onAppear(){ fetchItemsFromDB() }
                        .navigationBarTitle("\(self.listEntry.listName)",displayMode: .inline)
                      .navigationBarItems(trailing:
                        Button(action: {
                            print("Navigation ItemAdd Cart button pressed...")
                            self.isItemAddCardShown.toggle()
                            self.isAddCartIconClicked.toggle()
                            self.isAddItemMode.toggle()
                            print("ListName:\(self.listEntry.listName)")
                            print("List docID: \(self.$listEntry.docId)")
                        }) {
                            Image(systemName: "cart.badge.plus") .font(Font.system(size:30))
                        }.opacity(self.isAddItemMode ? 0 : 1))
            
            }
        //show alert to update Item name
            EditShoppingListItemAlertView(title: "Enter name of the item", isShown: $ediShoppingListItemAlert, shoppingListItem: self.$item.itemName, onAdd: {_ in
            updateShoppingListItemsInDB()
        }, itemQty: self.$newItemQty, itemQtyType: self.$itemQtyType)
    }
}


   
    //update Item name in DB
    func updateShoppingListItemsInDB(){
           guard let currentUser = Auth.auth().currentUser?.uid else { return }
           //guard let itemDocumentId = self.item.itemDocid else {return}
           itemName = self.item.itemName
        db.collection("Users").document(currentUser).collection("Lists").document(self.listEntry.docId!).collection("Items").document(itemDocId)
            .updateData(["Item Name" : itemName, "Item Qty" : self.newItemQty, "Item Qty Type": self.itemQtyType])
           { error in
               if let error = error{
                   print("error")
               } else{
                   print ("Data is updated")
               }
           }
       }
    
    //Function adds item to items list array
      func addNewItem()
      {
          if self.newItem.isEmpty
          {
              self.showErrorMessage.toggle()
            return
          }else{
              self.showErrorMessage = false
                let newItemEntry = Items(itemName: self.newItem, itemQty: self.newItemQty, itemQtyType: self.newQtyType[selectedPickerValue], itemIsShopped: self.newItemIsShopped)
            
            self.listEntry.eachListItems.append(newItemEntry)
            
            saveItemToDB()
            clearFields()
            
          }
      }
    
    func clearFields(){
        self.newItem = ""
        self.newItemQty = "0"
    }
    

    func deleteItem(at indexSet: IndexSet)
    {
       
        print("Inside delete item function")
             indexSet.forEach { index in
                 let listItemDocId = listEntry.eachListItems[index]
             guard let currentUser = Auth.auth().currentUser?.uid else { return }
                print(currentUser)
       
                db.collection("Users").document(currentUser).collection("Lists")
                    .document(listEntry.docId!)
                    .collection("Items")
                    .document(listItemDocId.itemDocid!)
                    .delete{
                error in
                if let error = error{
                    print(error.localizedDescription)
                } else {
                    print("deleteSuccess")
                }
            }
    }
}

    // Adds item to DB
    func saveItemToDB(){
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").document(self.listEntry.docId!).collection("Items").addDocument(data: ["Item Name":newItem, "Item Qty": newItemQty, "Item Qty Type": newQtyType[selectedPickerValue], "Item IsShopped": newItemIsShopped]){ error in
            if let error = error{
                print("Error saving document: \(error)")
            }else{
               print("Data is inserted")
            }
            
        }
    }
    
// fetchItems using SnapshotListener
    func fetchItemsFromDB() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").document(self.listEntry.docId!).collection("Items").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.listEntry.eachListItems = documents.map { (queryDocumentSnapshot) -> Items in
                let data = queryDocumentSnapshot.data()
                let itemDocIdData = queryDocumentSnapshot.documentID
                let itemNameData = data["Item Name"] as? String ?? ""
                let itemQtyData = data["Item Qty"] as? String ?? ""
                let itemQtyTypeData = data["Item Qty Type"] as? String ?? ""
                let itemIsShoppedData = data["Item IsShopped"] as? Bool ?? false
                let ItemData = Items(itemDocid: itemDocIdData, itemName: itemNameData, itemQty: itemQtyData, itemQtyType: itemQtyTypeData, itemIsShopped: itemIsShoppedData)
                return Items(itemDocid: itemDocIdData, itemName: itemNameData, itemQty: itemQtyData, itemQtyType: itemQtyTypeData, itemIsShopped: itemIsShoppedData)
            }
        }
    }
}

    
    
struct ItemRowView: View{
    @State var entry: Items
    @Binding var listEntry : ShoppingListEntry
    @Binding var isAddCartIconClicked:Bool
    var db = Firestore.firestore()
    
    
    var body: some View {
        
       // ScrollView{
           
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 2)
                    .fill(LinearGradient(gradient: Gradient(colors:[Color.white,Color.green]),startPoint: .topLeading,endPoint: .bottomTrailing))
                        .padding(.horizontal, 4)
                        .shadow(color: Color.black, radius: 3, x: 3, y: 3)
                    
            HStack(){
                Button(action: {
                    print("Checkbox clicked")
                    self.entry.itemIsShopped.toggle()
                    print("ItemIsShooped value after click: \(self.entry.itemIsShopped)")
                    guard let itemDocumentId = self.entry.itemDocid else {return}
                    itemSelectedUpdateInDB(itemDocumentId)
                    
                },label: {
                    //To check if screen in Add mode to remove checkboxes
                    if !isAddCartIconClicked{
                    Image(systemName: entry.itemIsShopped ? "checkmark.square.fill" : "square")
                        .font(Font.system(size:20))
                        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
                        .padding()
                    }
                })
               
                //Strikeout item details by checking the checkbox click status
                
                entry.itemIsShopped ? Text(self.entry.itemName).fontWeight(.bold).font(.body).strikethrough(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, color: /*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/) :
                Text(self.entry.itemName).fontWeight(.bold).font(.body)
                Spacer()
                entry.itemIsShopped ?
                    Text(self.entry.itemQty).font(.body).strikethrough(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, color: /*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/) :
                Text(self.entry.itemQty).font(.body)
                entry.itemIsShopped ?
                    Text(self.entry.itemQtyType).font(.body).strikethrough(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/, color: /*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/) :
                    Text(self.entry.itemQtyType).font(.body)
                   
            }.padding(.trailing,5)
            }
        }
}
    //Delete individual item
    func deleteItemFromDB(){
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        guard let itemDocumentId = self.entry.itemDocid else {return}
        
        if let index = self.listEntry.eachListItems.firstIndex(of:entry){
            print("index value insside delete function: \(index)")
            self.listEntry.eachListItems.remove(atOffsets: [index])
        }
        db.collection("Users").document(currentUser).collection("Lists").document(self.listEntry.docId!).collection("Items").document(itemDocumentId).delete(){
            error in
                if let error = error{
                    print("Error deleting document for item selected : \(error)")
                }else{
                   print(" Deleted item from DB")
                }
        }
        
    }
    
    //Update checkbox click status in DB
    func itemSelectedUpdateInDB(_ itemId:String)
    {
            print("Value of list docId: \(self.listEntry.docId!)")
            print("Value itemShopped inside function: \(self.entry.itemIsShopped)")
            print("Item Doc id inside function: \(String(describing: itemId))")
            
            guard let currentUser = Auth.auth().currentUser?.uid else { return }
            db.collection("Users").document(currentUser).collection("Lists").document(self.listEntry.docId!).collection("Items").document(itemId).updateData(["Item IsShopped":self.entry.itemIsShopped]){ error in
                if let error = error{
                    print("Error updating document for item selected : \(error)")
                }else{
                   print("Updated item document for item selection")
                }
            }
    }
}

//Struct for MicView
struct MicView : View{
    @State var listEntry : ShoppingListEntry
    @EnvironmentObject var speechData : SpeechData
    @Environment(\.presentationMode) var presentationMode
   
    @State var isOkPressed:Bool = false
    @State var spokenText:String = ""
    
    @State var spokenItem:String = ""
    @State var spokenQty:String = ""
    @State var spokenQtyType:String = ""
    @State var showInputVoiceErrorMessage = false
    
    var db = Firestore.firestore()
    
    var body: some View {
        
        ZStack
        {
            GeometryReader{ p in
            VStack(alignment: .leading){
                    HStack{
                    Button(action: {self.presentationMode.wrappedValue.dismiss()})
                    {
                        Image(systemName: "xmark.circle.fill").resizable()
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            .frame(width: 30, height: 30)
                    }
                    .padding(.leading,20)
                }.padding(.top,80)
            }
        }
            VStack{
            //Prints voice text
                Text("\(self.speechData.speech.outputText)")
                .font(.title)
                .padding(.top,20)
           
            Button(action: {
                print("Ok button pressed in mic view inside itemview file's struct")
                print("List doc id inside item file's MicView struct: \(self.listEntry.docId!)")
                withAnimation{
                    self.isOkPressed.toggle()
                    self.spokenText = self.speechData.speech.outputText //Assign spoken text to state variable
                }
                
                if isOkPressed{
                    if self.spokenText.isEmpty{
                        self.showInputVoiceErrorMessage.toggle()
                      return
                    }else{
                        self.showInputVoiceErrorMessage = false
                    //Split spoken text
                    splitSpokenText(self.spokenText)
                    addSpokenTextToList()
                    self.presentationMode.wrappedValue.dismiss()
                }
                }
                
            })
            {
                Text("Ok".uppercased())
                    .fontWeight(.heavy)
                    .frame(width:50,height:50)
                    .foregroundColor(.white)
                    .accentColor(Color.white)
                
            }.padding(.vertical,20)
            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
            .cornerRadius(10)
                
            //Gets speech button
              self.speechData.getButton()
            
        }
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        
        //Alert if no values entered in textfield
        .alert(isPresented: self.$showInputVoiceErrorMessage)
        {
            Alert(title: Text("Error"), message: Text("Please input some Item by clicking on Mic button!Input item as (ItemName, Qty, Qtytype): Eg: Salt hundred grams"), dismissButton: .default(Text("OK")))
        }
        
}
    
    //Functions splits spoken text and stores in variables
    func splitSpokenText(_ spokenText:String)
    {
        print("Inside split text function in Mic View")
        let spokenWords = self.spokenText.components(separatedBy: " ")
        
        print("Spoken text inside split function: \(spokenText)")
        print("Words array inside split function: \(spokenWords)")
        print("Spoken text no. of words: \(spokenWords.count)")
        
        switch spokenWords.count
        {
        case 4:
            self.spokenItem = spokenWords[0] + spokenWords[1]
            self.spokenQty = spokenWords[2]
            self.spokenQtyType = spokenWords[3]
        case 3:
            self.spokenItem = spokenWords[0]
            self.spokenQty = spokenWords[1]
            self.spokenQtyType = spokenWords[2]
        case 2:
            self.spokenItem = spokenWords[0]
            self.spokenQty = spokenWords[1]
            self.spokenQtyType = "KG"
        default:
            self.spokenItem = spokenWords[0]
            self.spokenQty = "0"
            self.spokenQtyType = "KG"
        }
           
    }
    
    //Function adds spoken text to Items array
    func addSpokenTextToList(){
        print("Inside ass Spoken function in Mic view struct")
        let newSpokenItemEntry = Items(itemName: self.spokenItem, itemQty: self.spokenQty, itemQtyType: self.spokenQtyType, itemIsShopped: false)
        self.listEntry.eachListItems.append(newSpokenItemEntry)
        
        saveSpokenTextToDB()
        
    }
    
    //Functions saves spoken text to DB
    func saveSpokenTextToDB(){
        print("Inside save function in Mic View struct")
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser).collection("Lists").document(self.listEntry.docId!).collection("Items").addDocument(data: ["Item Name":self.spokenItem, "Item Qty": self.spokenQty, "Item Qty Type": self.spokenQtyType, "Item IsShopped": false]){ error in
            if let error = error{
                print("Error saving document: \(error)")
            }else{
               print("Data is inserted")
            }
            
        }
    }
    
}


struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListItemView(listEntry: ShoppingListEntry(listName: "Good day"), item: Items(itemName: "", itemQty: "", itemQtyType: "", itemIsShopped: false), itemDocId: "", autoCompleteData: autoCompleteData)
    }
}
