import SwiftUI

struct EditTaskSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var appData: AppData
    
    let task: Task
    
    @State private var title: String
    @State private var description: String
    @State private var selectedDueDate: Date
    @State private var priority: String
    
    init(task: Task, appData: AppData) {
        self.task = task
        self.appData = appData
        
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _priority = State(initialValue: task.priority)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        let parsedDate = formatter.date(from: task.dueDate) ?? Date()
        _selectedDueDate = State(initialValue: parsedDate)
    }
    
    private var formattedDueDate: String {
        selectedDueDate.formatted(date: .abbreviated, time: .shortened)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Task Info") {
                    TextField("Task Title", text: $title)
                    TextField("Description", text: $description)
                    
                    DatePicker(
                        "Due Date",
                        selection: $selectedDueDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    
                    TextField("Priority", text: $priority)
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
        }
    }
    
    private func saveChanges() {
        guard let index = appData.tasks.firstIndex(where: { $0.id == task.id }) else {
            dismiss()
            return
        }
        
        appData.tasks[index].title = title
        appData.tasks[index].description = description
        appData.tasks[index].dueDate = formattedDueDate
        appData.tasks[index].priority = priority
        
        NotificationManager.shared.scheduleTaskUpdatedNotification(taskTitle: title)
        NotificationManager.shared.scheduleDueReminderNotification(taskTitle: title, dueDate: selectedDueDate)
        
        dismiss()
    }
}
