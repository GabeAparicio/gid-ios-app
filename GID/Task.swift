import Foundation

struct Task: Identifiable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var dueDate: String
    var priority: String
    
    init(id: UUID = UUID(), title: String, description: String, dueDate: String, priority: String) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.priority = priority
    }
}
