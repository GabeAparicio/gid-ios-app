import SwiftUI

struct TaskDetailsView: View {
    
    @Binding var showMenu: Bool
    @Binding var selectedScreen: AppScreen
    @ObservedObject var appData: AppData
    
    @State private var editMode = false
    @State private var editTitle = ""
    @State private var editDescription = ""
    @State private var editDueDate = ""
    @State private var editPriority = ""
    
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
                
                Spacer()
                
                if let task = appData.selectedTask {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        if editMode {
                            TextField("TITLE", text: $editTitle)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            
                            TextField("DESCRIPTION", text: $editDescription)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                            
                            TextField("DUE DATE", text: $editDueDate)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                            
                            TextField("PRIORITY", text: $editPriority)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                        } else {
                            Text(task.title.uppercased())
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("DESCRIPTION: \(task.description.uppercased())")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("DUE DATE: \(task.dueDate.uppercased())")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("PRIORITY: \(task.priority.uppercased())")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                        }
                        
                        HStack(spacing: 16) {
                            Button(action: {
                                if editMode {
                                    if let index = appData.tasks.firstIndex(where: { $0.id == task.id }) {
                                        appData.tasks[index].title = editTitle
                                        appData.tasks[index].description = editDescription
                                        appData.tasks[index].dueDate = editDueDate
                                        appData.tasks[index].priority = editPriority
                                        appData.selectedTask = appData.tasks[index]
                                    }
                                    editMode = false
                                } else {
                                    editTitle = task.title
                                    editDescription = task.description
                                    editDueDate = task.dueDate
                                    editPriority = task.priority
                                    editMode = true
                                }
                            }) {
                                Text(editMode ? "SAVE EDIT" : "EDIT TASK")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 10)
                                    .cornerRadius(16)
                            }
                            .buttonStyle(PressableButtonStyle())
                            
                            Button(action: {
                                appData.tasks.removeAll { $0.id == task.id }
                                appData.selectedTask = nil
                                selectedScreen = .home
                            }) {
                                Text("DELETE TASK")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 10)
                                    .cornerRadius(16)
                            }
                            .buttonStyle(PressableButtonStyle())
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(20)
                    .padding(.horizontal, 28)
                } else {
                    Text("NO TASK SELECTED")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("GID!")
                    .font(.custom("BlackOpsOne-Regular", size: 18))
                    .foregroundColor(.white.opacity(0.75))
                    .padding(.bottom, 16)
            }
        }
    }
}

#Preview {
    TaskDetailsView(
        showMenu: .constant(false),
        selectedScreen: .constant(.taskDetails),
        appData: AppData()
    )
}
