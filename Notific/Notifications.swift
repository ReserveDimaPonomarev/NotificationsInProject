//
//  Notifications.swift
//  Notific
//
//  Created by Дмитрий Пономарев on 20.04.2023.
//

import Foundation
import NotificationCenter

class Notifications: NotificationCenter {
    
    let notificationCenter = UNUserNotificationCenter.current()

    func requestAutorisation() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            print("request is \(granted)")
            guard granted else { return }
            self.requestNotificationSettings()
        }
    }
    
    private func requestNotificationSettings() {
        notificationCenter.getNotificationSettings { (settins) in
        }
    }
    
    func scheduleNotification(notificationType: String) {
        
        let userCategoryOfAction = "User Active"
        
        let content = UNMutableNotificationContent()
        content.title = notificationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.body = "Example of Notification \(notificationType)"
        content.categoryIdentifier = userCategoryOfAction
        let identidier = "Local notification"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: identidier, content: content, trigger: trigger)
        
        let path = Bundle.main.path(forResource: "icon", ofType: "png")!
        let url = URL(filePath: path)
        do {
            let attachment = try UNNotificationAttachment(identifier: "icon", url: url)
            content.attachments = [attachment]
        }catch{
            print(error.localizedDescription)
        }
        
        notificationCenter.add(request)
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze Action", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete Action", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: userCategoryOfAction, actions: [snoozeAction, deleteAction], intentIdentifiers: [])
        notificationCenter.setNotificationCategories([category])
        
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

extension Notifications: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local Notification" {
            print("local notification")
        }
            switch response.actionIdentifier {
            case UNNotificationDismissActionIdentifier:     print("Dismiss")
            case UNNotificationDefaultActionIdentifier:     print("Default")
            case "Snooze Action":                           scheduleNotification(notificationType: "Reminder")
            case "Delete Action":                           print("Delete")
            default:                                        print("Unknown action")
            }
        completionHandler()
    }
}
