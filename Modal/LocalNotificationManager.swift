//
//  LocalNotificationManager.swift
//  ShoppingList
//
//  Created by Jayabharathi Jayaraman on 2021-02-22.
//

import Foundation
import SwiftUI

class LocalNotificationManager {
    
    var notification = [Notification]()
    init() {
        print("Notification")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){
    success, error in
            if success == true && error == nil {
                print("SuccessNotification")
            } else {
                print("error")
            }
            
        }
    }
    
    func sendNotification(title: String, subtitle: String?, body: String, launchIn: Double){
        let content = UNMutableNotificationContent()
        content.title = title
        if let subtitle = subtitle{
            content.subtitle = subtitle
            
        }
        content.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: launchIn, repeats: false)
         let request = UNNotificationRequest(identifier: "demoNotification", content: content, trigger: trigger)
     
        // 5.
             UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
