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
    
    func scheduleDueReminderNotification(taskTitle: String, dueDate: Date) {
        let now = Date()
        if dueDate <= now { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        
        let calendar = Calendar.current
        if calendar.isDateInToday(dueDate) {
            content.body = "Your task \"\(taskTitle)\" is due today."
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            content.body = "Reminder: \"\(taskTitle)\" is due on \(formatter.string(from: dueDate))."
        }
        
        content.sound = .default
        
        let triggerDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}
