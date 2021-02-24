//
//  AddNewListAlertView.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-03.
//
import Foundation
import SwiftUI
import Firebase

struct AddNewListAlertView: View {
    
    let screenSize = UIScreen.main.bounds
    var title: String = ""
    @Binding var isShown: Bool
    @Binding var listName: String
    var onAdd: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    // Added for Notification functionality, date picker variables
    @Binding var dueDate : String
    @State var date : Date?
    @State var dueDatePicker = Date()
    var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
        formatter.dateStyle = .short
            return formatter
        }
    @State var notificationListName: String = ""
    @State var notificationCurrentUser: String = ""
   
    var body: some View {
        
        VStack(alignment: .center) {
            
            Text(title)
                .font(.headline)
            TextField("", text: $listName, onEditingChanged: { (changed) in })
                .textFieldStyle(RoundedBorderTextFieldStyle())
           
            // Added for Notification functionality , Date Picker layout
            HStack{
                
               Text("DueDate")
            DueDatePicker(placeholder: "", date: self.$date)
              
            }
            Divider()
            HStack(alignment: .center) {
                Button("Cancel") {
                    self.isShown = false
                    self.onCancel()
                }.foregroundColor(.red)
                
                Divider()
                Button("Add") {
                    self.notificationListName = self.listName
                    self.dueDate = dateFormatter.string(from: self.date!)
                    self.isShown = false
                    self.onAdd(self.listName)
                    self.listName = ""
                    getCurrentUserInfo()
                }.disabled(listName.isEmpty || date == nil )
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.2)
        .background(Color(#colorLiteral(red: 0.9268686175, green: 0.9416290522, blue: 0.9456014037, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        
        .shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 3, x: -9, y: -9)
        
    }
    // get current user name from db to show in notification
    func getCurrentUserInfo(){
        let db = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(currentUser)
            .addSnapshotListener{(snap,err) in
            if err != nil{
                print("Error fetching data from firebase")
                return
            }
                if let data = snap?.data(){
                    self.notificationCurrentUser = (data["UserName"] as? String)!
                    print("Current Name: \(self.notificationCurrentUser)")
                    sendNotification()
                }
        }
    }
    // to show local notification when shopping list is there to buy for current date.
    func sendNotification(){
       let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        let entry = ShoppingListEntry(listName: "")
        var date : String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let date = formatter.string(from: entry.date)
        return date
    }
        if self.dueDate == date {
        let content = UNMutableNotificationContent()
            content.title = ("Hello \(self.notificationCurrentUser)")
            content.subtitle = "You have one shopping list to purchase today!"
            content.body = notificationListName
        let date = Date().addingTimeInterval(10)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        center.add(request) { (error) in
            // Check the error parameter and handle any errors
        }
    }
}
}

struct AddNewListAlertView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewListAlertView(title: "Add Item", isShown: .constant(true), listName: .constant(""), dueDate: .constant(""), notificationListName: "")
    }
}
