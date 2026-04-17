import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
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
