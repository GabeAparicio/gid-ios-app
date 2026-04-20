//
//  EditTaskSheet.swift
//  GID! (Get It Done!)
//
//  Author: Wassn Al Nabhan - 101468092
//  Co-editor: Gabriel Aparicio - 101419420
//  Changes by co-editor: Added reminder editing, validation logic, notification updates, and persistent save support.
//  External assistance note:
//  Reminder validation, task update flow, and save logic in this file were developed with AI guidance,
//  then reviewed, tested, and understood by the project team.
//

import SwiftUI

struct EditTaskSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var appData: AppData
    
    let task: Task
    
    @State private var title: String
    @State private var description: String
    @State private var selectedDueDate: Date
    @State private var firstReminderDate: Date
    @State private var secondReminderDate: Date
    @State private var priority: String
    
    @State private var showValidationAlert = false
    @State private var validationMessage = ""
    
    init(task: Task, appData: AppData) {
        self.task = task
        self.appData = appData
        
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _priority = State(initialValue: task.priority)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        // Converts saved string values back into Date objects so they can be edited with DatePickers.
        let parsedDueDate = formatter.date(from: task.dueDate) ?? Date()
        let parsedFirstReminder = formatter.date(from: task.firstReminder) ?? Date()
        let parsedSecondReminder = formatter.date(from: task.secondReminder) ?? Date()
        
        _selectedDueDate = State(initialValue: parsedDueDate)
        _firstReminderDate = State(initialValue: parsedFirstReminder)
        _secondReminderDate = State(initialValue: parsedSecondReminder)
    }
    
    private var formattedDueDate: String {
        selectedDueDate.formatted(date: .abbreviated, time: .shortened)
    }
    
    private var formattedFirstReminder: String {
        firstReminderDate.formatted(date: .abbreviated, time: .shortened)
    }
    
    private var formattedSecondReminder: String {
        secondReminderDate.formatted(date: .abbreviated, time: .shortened)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Task Info") {
                    TextField("Task Title", text: $title)
                    TextField("Description", text: $description)
                }
                
                Section("Dates") {
                    DatePicker(
                        "Due Date",
                        selection: $selectedDueDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    
                    DatePicker(
                        "First Reminder",
                        selection: $firstReminderDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    
                    DatePicker(
                        "Second Reminder",
                        selection: $secondReminderDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
                
                Section("Priority") {
                    Picker("Priority", selection: $priority) {
                        Text("Low").tag("Low")
                        Text("Medium").tag("Medium")
                        Text("High").tag("High")
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
            .alert("Invalid Task Data", isPresented: $showValidationAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(validationMessage)
            }
        }
    }
    
    // Validates edited task data, updates the selected task, reschedules reminders, and saves changes.
    private func saveChanges() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPriority = priority.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            validationMessage = "Please enter a task title."
            showValidationAlert = true
            return
        }
        
        guard !trimmedDescription.isEmpty else {
            validationMessage = "Please enter a task description."
            showValidationAlert = true
            return
        }
   
        // Ensures reminders are scheduled before the task due date and in logical order.
        guard firstReminderDate < selectedDueDate else {
            validationMessage = "The first reminder must be before the due date."
            showValidationAlert = true
            return
        }
        
        guard secondReminderDate < selectedDueDate else {
            validationMessage = "The second reminder must be before the due date."
            showValidationAlert = true
            return
        }
        
        guard firstReminderDate <= secondReminderDate else {
            validationMessage = "The first reminder should be earlier than or equal to the second reminder."
            showValidationAlert = true
            return
        }
        
        guard let index = appData.tasks.firstIndex(where: { $0.id == task.id }) else {
            dismiss()
            return
        }
        
        appData.tasks[index].title = trimmedTitle
        appData.tasks[index].description = trimmedDescription
        appData.tasks[index].dueDate = formattedDueDate
        appData.tasks[index].priority = trimmedPriority
        appData.tasks[index].firstReminder = formattedFirstReminder
        appData.tasks[index].secondReminder = formattedSecondReminder
        
        NotificationManager.shared.scheduleTaskUpdatedNotification(taskTitle: trimmedTitle)
        
        NotificationManager.shared.scheduleReminderNotification(
            taskTitle: trimmedTitle,
            reminderDate: firstReminderDate,
            reminderLabel: "First Reminder"
        )
        
        NotificationManager.shared.scheduleReminderNotification(
            taskTitle: trimmedTitle,
            reminderDate: secondReminderDate,
            reminderLabel: "Second Reminder"
        )
        
        appData.saveTasks()
        dismiss()
    }
}
