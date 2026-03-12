import Foundation
import Combine

final class AppData: ObservableObject {
    
    @Published var tasks: [Task] = [
        Task(title: "Gym Workout", description: "Leg day and abs, 15 mins cardio warm up", dueDate: "Today 5PM", priority: "Medium"),
        Task(title: "Buy Groceries", description: "Milk, eggs, fruit, bread", dueDate: "Today 8PM", priority: "High"),
        Task(title: "Quiz", description: "Study SwiftUI notes", dueDate: "Friday", priority: "High"),
        Task(title: "Clean Room", description: "Vacuum and organize desk", dueDate: "Tomorrow", priority: "Low")
    ]
    
    @Published var selectedTask: Task? = nil
}
