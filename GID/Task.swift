//
//  Task.swift
//  GID! (Get It Done!)
//
//  Author: Wassn Al Nabhan - 101468092
//  Co-editor: Gabriel Aparicio - 101419420
//  Changes by co-editor: Added reminder fields and Codable support for persistence.
//  External assistance note:
//  Some model updates in this file were completed with AI guidance,
//  then reviewed and understood by the project team.
//

import Foundation

// Task model representing a single task item in the application.
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
