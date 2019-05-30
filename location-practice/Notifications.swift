//
//  Notifications.swift
//  location-practice
//
//  Created by jinsei_shima on 2019/05/31.
//  Copyright © 2019 jinsei_shima. All rights reserved.
//

import Foundation
import UserNotifications

public class Notification {
    
    public static func notification(title: String, subTitle: String, body: String) {
        
        let content: UNMutableNotificationContent = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        content.body = body
        
        let trigger: UNTimeIntervalNotificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requestIdentifier: String = "notification_in_local"
        let request: UNNotificationRequest = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            
        })
    }
}
