import SwiftUI

struct ContentView: View {
    
    @Binding var showMenu: Bool
    @Binding var selectedScreen: AppScreen
    @ObservedObject var appData: AppData
    
    @State private var expandedTaskID: UUID? = nil
    
    var sortedTaskIndices: [Int] {
        appData.tasks.indices.sorted { first, second in
            let firstTask = appData.tasks[first]
            let secondTask = appData.tasks[second]
            
            if firstTask.completed == secondTask.completed {
                return firstTask.title < secondTask.title
            }
            
            return !firstTask.completed && secondTask.completed
        }
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
                    }
                    
                    Text("MY TASKS")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 18) {
                        
                        ForEach(sortedTaskIndices, id: \.self) { index in
                            let task = appData.tasks[index]
                            
                            VStack(spacing: 0) {
                                
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        if expandedTaskID == task.id {
                                            expandedTaskID = nil
                                        } else {
                                            expandedTaskID = task.id
                                        }
                                    }
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(task.title.uppercased())
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(task.completed ? .gray : .black)
                                                .strikethrough(task.completed)
                                            
                                            Text("Due: \(task.dueDate)")
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(.black.opacity(0.75))
                                            
                                            Text("Priority: \(task.priority)")
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(.black.opacity(0.75))
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(spacing: 10) {
                                            Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                                                .font(.title2)
                                                .foregroundColor(task.completed ? .green : .gray)
                                            
                                            Image(systemName: expandedTaskID == task.id ? "chevron.up" : "chevron.down")
                                                .font(.caption)
                                                .foregroundColor(.black.opacity(0.6))
                                        }
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.95))
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                }
                                .buttonStyle(PressableButtonStyle())
                                
                                if expandedTaskID == task.id {
                                    VStack(alignment: .leading, spacing: 14) {
                                        
                                        Text("Description")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Text(task.description)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundColor(.black)
                                        
                                        Button(action: {
                                            withAnimation {
                                                appData.tasks[index].completed.toggle()
                                            }
                                        }) {
                                            HStack {
                                                Image(systemName: appData.tasks[index].completed ? "checkmark.circle.fill" : "checkmark.circle")
                                                
                                                Text(appData.tasks[index].completed ? "MARK AS INCOMPLETE" : "MARK AS COMPLETE")
                                                    .font(.system(size: 15, weight: .bold))
                                            }
                                            .foregroundColor(.black)
                                            .padding(.horizontal, 18)
                                            .padding(.vertical, 10)
                                        }
                                        .buttonStyle(PressableButtonStyle())
                                    }
                                    .padding(18)
                                    .background(Color.white.opacity(0.97))
                                    .cornerRadius(18)
                                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                    .padding(.top, 10)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
                
                Text("GID!")
                    .font(.custom("BlackOpsOne-Regular", size: 18))
                    .foregroundColor(.white.opacity(0.75))
                    .padding(.bottom, 16)
            }
        }
    }
}
