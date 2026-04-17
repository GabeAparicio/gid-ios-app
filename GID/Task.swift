import Foundation

struct Task: Identifiable, Equatable, Codable {
    let id: UUID
    var title: String
    var description: String
    var dueDate: String
    var priority: String
    var completed: Bool
    var firstReminder: String
    var secondReminder: String
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        dueDate: String,
        priority: String,
        completed: Bool = false,
        firstReminder: String = "",
        secondReminder: String = ""
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.priority = priority
        self.completed = completed
        self.firstReminder = firstReminder
        self.secondReminder = secondReminder
    }
}
