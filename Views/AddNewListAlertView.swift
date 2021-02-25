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
    //@State var dueDatePicker = Date()
    var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
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
                
              // Text("DueDate")
            DueDatePicker(placeholder: "", date: self.$date)
         //       DatePicker("DueDate", selection: $dueDatePicker, in: Date()...)
            }
            Divider()
            HStack(alignment: .center) {
                Button("Cancel") {
                    self.isShown = false
                    self.onCancel()
                }.foregroundColor(.red)
                
                Divider()
                Button("Add") {
                    print("due\(dueDatePicker)")
                    self.notificationListName = self.listName
                    self.dueDate = dateFormatter.string(from: self.date!)
                    self.isShown = false
                    self.onAdd(self.listName)
                    self.listName = ""
                    getCurrentUserInfo()
                }.disabled(listName.isEmpty || dueDatePicker == nil )
            }
        }
        .onAppear(){
            //Asking for user authorization
                               UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]){ success,error in
                                   if success{
                                       print("ALL Set")
                                   }else if let error = error{
                                       print(error.localizedDescription)
                                   }
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
        print(self.dueDate)
       /*let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }*/
        //let entry = ShoppingListEntry(listName: "")
       // let date = dateFormatter.string(from: entry.date)
      
        let content = UNMutableNotificationContent()
            content.title = ("Hello \(self.notificationCurrentUser)")
            content.subtitle = "You have one shopping list to purchase today!"
            content.body = notificationListName
            content.sound = UNNotificationSound.default
        let date = self.date!.addingTimeInterval(10)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request,withCompletionHandler: {error in
                 if error != nil{
                                        print("No Notification")
                                    }
                                    
                                })
        /*center.add(request) { (error) in
            // Check the error parameter and handle any errors
            print("no notifi")
        }*/
    
}
}

struct AddNewListAlertView_Previews: PreviewProvider {
    static var previews: some View {                          AddNewListAlertView(title: "Add Item", isShown: .constant(true), listName: .constant(""), dueDate: .constant(""), dueDatePicker: Date(), notificationListName: "")
    }
}
