//
//  NotificationManager.swift
//  GID! (Get It Done!)
//
//  Author: Gabriel Aparicio - 101419420
//  Co-editor: Wassn Al Nabhan - 101468092
//  Changes by co-editor: Assisted with notification logic and integration with task features.
//  External assistance note:
//  Local notification scheduling logic in this file was developed with AI guidance,
//  then reviewed, tested, and understood by the project team.
//

import Foundation
import UserNotifications

// Handles all local notification-related functionality for the app.
class NotificationManager {
    
    static let shared = NotificationManager()
    
    // Requests permission from the user to display notifications.
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    // Sends a short confirmation notification when a task is added.
    func scheduleTaskAddedNotification(taskTitle: String) {
        let content = UNMutableNotificationContent()
        content.title = "Task Added"
        content.body = "\"\(taskTitle)\" was added successfully."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // Sends a short confirmation notification when a task is updated.
    func scheduleTaskUpdatedNotification(taskTitle: String) {
        let content = UNMutableNotificationContent()
        content.title = "Task Updated"
        content.body = "\"\(taskTitle)\" was updated."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // Schedules a reminder notification at a specific date/time if it is in the future.
    func scheduleReminderNotification(taskTitle: String, reminderDate: Date, reminderLabel: String) {
        let now = Date()
        if reminderDate <= now { return }
        
        let content = UNMutableNotificationContent()
        content.title = reminderLabel
        content.body = "Reminder: \"\(taskTitle)\" is coming up."
        content.sound = .default
        
        let calendar = Calendar.current
        let triggerDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}
