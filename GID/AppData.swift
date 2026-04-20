//
//  AppData.swift
//  GID! (Get It Done!)
//
//  Author: Gabriel Aparicio - 101419420
//  Co-editor: Wassn Al Nabhan - 101468092
//  Changes by co-editor: Added sample starter tasks and assisted with app data flow/testing.
//  External assistance note:
//  Persistence logic using UserDefaults and Codable was developed with AI guidance,
//  then reviewed, tested, and understood by the project team.
//

import Foundation
import SwiftUI
import Combine

// AppData stores the shared task list for the app and keeps track of the currently selected task.
class AppData: ObservableObject {
    
    // Whenever the task list changes, it is automatically saved to local storage.
    @Published var tasks: [Task] = [] {
        didSet {
            saveTasks()
        }
    }
    
    @Published var selectedTask: Task?
    
    // Key used to store and retrieve task data from UserDefaults.
    private let tasksKey = "saved_tasks"
    
    init() {
        loadTasks()
        
        // If no saved tasks exist yet, preload the app with sample tasks.
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
    
    // Encodes the task array and saves it to UserDefaults for persistence between app launches.
    func saveTasks() {
        do {
            let encoded = try JSONEncoder().encode(tasks)
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        } catch {
            print("Failed to save tasks: \(error.localizedDescription)")
        }
    }
    
    // Loads previously saved tasks from UserDefaults when the app starts.
    func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: tasksKey) else { return }
        
        do {
            tasks = try JSONDecoder().decode([Task].self, from: data)
        } catch {
            print("Failed to load tasks: \(error.localizedDescription)")
        }
    }
}
