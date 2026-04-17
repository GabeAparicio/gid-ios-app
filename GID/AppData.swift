import Foundation
import SwiftUI
import Combine

class AppData: ObservableObject {
    @Published var tasks: [Task] = [] {
        didSet {
            saveTasks()
        }
    }
    
    @Published var selectedTask: Task?
    
    private let tasksKey = "saved_tasks"
    
    init() {
        loadTasks()
        
        if tasks.isEmpty {
            tasks = [
                Task(
                    title: "Gym Workout",
                    description: "Leg day and abs, 15 mins cardio warm up",
                    dueDate: "Apr 18, 6:00 PM",
                    priority: "High",
                    completed: false,
                    firstReminder: "Apr 18, 4:00 PM",
                    secondReminder: "Apr 18, 5:00 PM"
                ),
                Task(
                    title: "COMP3097 Final Project",
                    description: "Finish the mobile app and test all features",
                    dueDate: "Apr 20, 11:59 PM",
                    priority: "High",
                    completed: false,
                    firstReminder: "Apr 20, 8:00 PM",
                    secondReminder: "Apr 20, 10:00 PM"
                )
            ]
        }
    }
    
    func saveTasks() {
        do {
            let encoded = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        } catch {
            print("Failed to save tasks: \(error.localizedDescription)")
        }
    }
    
    func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: tasksKey) else { return }
        
        do {
            tasks = try JSONDecoder().decode([Task].self, from: data)
        } catch {
            print("Failed to load tasks: \(error.localizedDescription)")
        }
    }
}
