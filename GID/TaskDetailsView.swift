import SwiftUI

struct TaskDetailsView: View {
    
    @Binding var showMenu: Bool
    @Binding var selectedScreen: AppScreen
    @ObservedObject var appData: AppData
    
    @State private var expandedTaskID: UUID? = nil
    @State private var editingTask: Task? = nil
    
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
                    }
                    
                    Text("TASK DETAILS")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        ForEach(appData.tasks) { task in
                            
                            VStack(spacing: 0) {
                                
                                Button(action: {
                                    withAnimation {
                                        expandedTaskID = (expandedTaskID == task.id ? nil : task.id)
                                    }
                                }) {
                                    HStack {
                                        Text(task.title.uppercased())
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Image(systemName: expandedTaskID == task.id ? "chevron.up" : "chevron.down")
                                            .foregroundColor(.black.opacity(0.7))
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.95))
                                    .cornerRadius(18)
                                }
                                .buttonStyle(PressableButtonStyle())
                                
                                if expandedTaskID == task.id {
                                    VStack(alignment: .leading, spacing: 14) {
                                        
                                        Text("Description")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Text(task.description)
                                        
                                        Text("Due: \(task.dueDate)")
                                        Text("Priority: \(task.priority)")
                                        
                                        HStack {
                                            Button("EDIT TASK") {
                                                editingTask = task
                                            }
                                            
                                            Button("DELETE TASK") {
                                                deleteTask(task)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.97))
                                    .cornerRadius(18)
                                    .padding(.top, 8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                
                Text("GID!")
                    .font(.custom("BlackOpsOne-Regular", size: 18))
                    .foregroundColor(.white.opacity(0.75))
                    .padding(.bottom, 16)
            }
        }
        .sheet(item: $editingTask) { task in
            EditTaskSheet(task: task, appData: appData)
        }
    }
    
    private func deleteTask(_ task: Task) {
        appData.tasks.removeAll { $0.id == task.id }
        
        if expandedTaskID == task.id {
            expandedTaskID = nil
        }
    }
}
