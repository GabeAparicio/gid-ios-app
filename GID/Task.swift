import Foundation

struct Task: Identifiable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var dueDate: String
    var priority: String
    var completed: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        dueDate: String,
        priority: String,
        completed: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.priority = priority
        self.completed = completed
    }
}
