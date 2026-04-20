//
//  AddTaskView.swift
//  GID! (Get It Done!)
//
//  Author: Gabriel Aparicio - 101419420
//  Co-editor: Wassn Al Nabhan - 101468092
//  Changes by co-editor: Assisted with UI layout, reminder fields, and task input flow.
//  External assistance note:
//  Validation logic and reminder-handling logic in this file were developed with AI guidance,
//  then reviewed, tested, and understood by the project team.
//

import SwiftUI

struct AddTaskView: View {
    
    @Binding var showMenu: Bool
    @Binding var selectedScreen: AppScreen
    @ObservedObject var appData: AppData
    
    @State private var taskTitle = ""
    @State private var taskDescription = ""
    @State private var selectedDueDate = Date()
    @State private var firstReminderDate = Date()
    @State private var secondReminderDate = Date()
    @State private var priority = "Medium"
    
    @State private var showValidationAlert = false
    @State private var validationMessage = ""
    
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
        
        ZStack {
            
            LinearGradient(
                colors: [
                    Color(hex: "#B5E8FF").opacity(0.55),
                    Color(hex: "#6D8B99").opacity(0.65)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                
                ZStack {
                    HStack {
                        
                        Button(action: {
                            withAnimation {
                                showMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                showMenu = false
                                selectedScreen = .home
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Text("ADD TASK")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
                        
                        Group {
                            Text("TASK TITLE")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            TextField("ENTER TASK NAME", text: $taskTitle)
                                .textFieldStyle(.plain)
                                .padding()
                                .background(Color.white.opacity(0.95))
                                .cornerRadius(12)
                        }
                        
                        Group {
                            Text("DESCRIPTION")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            TextField("ENTER DESCRIPTION", text: $taskDescription)
                                .textFieldStyle(.plain)
                                .padding()
                                .background(Color.white.opacity(0.95))
                                .cornerRadius(12)
                        }
                        
                        Group {
                            Text("DUE DATE")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            DatePicker(
                                "SELECT DATE",
                                selection: $selectedDueDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .padding()
                            .background(Color.white.opacity(0.95))
                            .cornerRadius(12)
                            .accentColor(.black)
                        }
                        
                        Group {
                            Text("FIRST REMINDER")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            DatePicker(
                                "SELECT FIRST REMINDER",
                                selection: $firstReminderDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .padding()
                            .background(Color.white.opacity(0.95))
                            .cornerRadius(12)
                            .accentColor(.black)
                        }
                        
                        Group {
                            Text("SECOND REMINDER")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            DatePicker(
                                "SELECT SECOND REMINDER",
                                selection: $secondReminderDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .padding()
                            .background(Color.white.opacity(0.95))
                            .cornerRadius(12)
                            .accentColor(.black)
                        }
                        
                        Group {
                            Text("PRIORITY")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            
                            Picker("Select Priority", selection: $priority) {
                                Text("Low").tag("Low")
                                Text("Medium").tag("Medium")
                                Text("High").tag("High")
                            }
                            .pickerStyle(.segmented)
                            .padding()
                            .background(Color.white.opacity(0.95))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 24)
                }
                
                Button(action: {
                    saveTask()
                }) {
                    Text("SAVE TASK")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                }
                .buttonStyle(PressableButtonStyle())
                .padding(.bottom, 20)
                
                Text("GID!")
                    .font(.custom("BlackOpsOne-Regular", size: 18))
                    .foregroundColor(.white.opacity(0.75))
                    .padding(.bottom, 16)
            }
        }
        .alert("Invalid Task Data", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(validationMessage)
        }
    }
    
    // Validates task input, creates a new task, and schedules reminder notifications.
    private func saveTask() {
        let trimmedTitle = taskTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = taskDescription.trimmingCharacters(in: .whitespacesAndNewlines)
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
        
        // Reminder times must be scheduled before the task due date.
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
        
        let newTask = Task(
            title: trimmedTitle,
            description: trimmedDescription,
            dueDate: formattedDueDate,
            priority: trimmedPriority,
            firstReminder: formattedFirstReminder,
            secondReminder: formattedSecondReminder
        )
        
        appData.tasks.append(newTask)
        appData.selectedTask = newTask
        
        NotificationManager.shared.scheduleTaskAddedNotification(taskTitle: trimmedTitle)
        
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
        
        taskTitle = ""
        taskDescription = ""
        selectedDueDate = Date()
        firstReminderDate = Date()
        secondReminderDate = Date()
        priority = "Medium"
        
        selectedScreen = .home
    }
}

#Preview {
    AddTaskView(
        showMenu: .constant(false),
        selectedScreen: .constant(.addTask),
        appData: AppData()
    )
}
