import SwiftUI

struct AddTaskView: View {
    
    @Binding var showMenu: Bool
    @Binding var selectedScreen: AppScreen
    @ObservedObject var appData: AppData
    
    @State private var taskTitle = ""
    @State private var taskDescription = ""
    @State private var selectedDueDate = Date()
    @State private var priority = ""
    
    private var formattedDueDate: String {
        selectedDueDate.formatted(date: .abbreviated, time: .shortened)
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
                                showMenu.toggle()
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
                
                Spacer()
                
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
                        Text("PRIORITY")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                        
                        TextField("LOW, MEDIUM, HIGH", text: $priority)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(Color.white.opacity(0.95))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 28)
                
                Spacer()
                
                Button(action: {
                    let newTask = Task(
                        title: taskTitle,
                        description: taskDescription,
                        dueDate: formattedDueDate,
                        priority: priority
                    )
                    
                    appData.tasks.append(newTask)
                    appData.selectedTask = newTask
                    
                    NotificationManager.shared.scheduleTaskAddedNotification(taskTitle: taskTitle)
                    NotificationManager.shared.scheduleDueReminderNotification(taskTitle: taskTitle, dueDate: selectedDueDate)
                    
                    taskTitle = ""
                    taskDescription = ""
                    selectedDueDate = Date()
                    priority = ""
                    
                    selectedScreen = .home
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
    }
}

#Preview {
    AddTaskView(
        showMenu: .constant(false),
        selectedScreen: .constant(.addTask),
        appData: AppData()
    )
}
