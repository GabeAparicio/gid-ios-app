import SwiftUI

struct MainMenuView: View {
    
    @State private var showMenu = false
    @State private var selectedScreen: AppScreen = .home
    @StateObject private var appData = AppData()
    
    @State private var showDueTodayAlert = false
    @State private var dueTodayTasks: [Task] = []
    @State private var currentDueTask: Task? = nil
    
    var body: some View {
        ZStack {
            
            Group {
                switch selectedScreen {
                case .home:
                    ContentView(
                        showMenu: $showMenu,
                        selectedScreen: $selectedScreen,
                        appData: appData
                    )
                case .addTask:
                    AddTaskView(
                        showMenu: $showMenu,
                        selectedScreen: $selectedScreen,
                        appData: appData
                    )
                case .taskDetails:
                    TaskDetailsView(
                        showMenu: $showMenu,
                        selectedScreen: $selectedScreen,
                        appData: appData
                    )
                }
            }
            
            if showMenu {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }
                
                HStack {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        Text("MENU")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.top, 60)
                        
                        Button("HOME") {
                            selectedScreen = .home
                            withAnimation {
                                showMenu = false
                            }
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        
                        Button("ADD TASK") {
                            selectedScreen = .addTask
                            withAnimation {
                                showMenu = false
                            }
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        
                        Button("TASK DETAILS") {
                            if appData.selectedTask == nil, let firstTask = appData.tasks.first {
                                appData.selectedTask = firstTask
                            }
                            selectedScreen = .taskDetails
                            withAnimation {
                                showMenu = false
                            }
                        }
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .frame(width: 220)
                    .background(Color.white.opacity(0.95))
                    
                    Spacer()
                }
                .ignoresSafeArea()
            }
        }
        .onAppear {
            loadDueTodayTasks()
        }
        .alert("Task Reminder", isPresented: $showDueTodayAlert) {
            Button("Mark Complete") {
                if let task = currentDueTask,
                   let index = appData.tasks.firstIndex(where: { $0.id == task.id }) {
                    appData.tasks[index].completed = true
                }
                showNextDueTask()
            }
            
            Button("Later", role: .cancel) {
                showNextDueTask()
            }
        } message: {
            if let task = currentDueTask {
                Text("\"\(task.title)\" is due today. Mark complete?")
            }
        }
    }
    
    private func loadDueTodayTasks() {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        dueTodayTasks = appData.tasks.filter { task in
            guard !task.completed else { return false }
            
            if task.dueDate.lowercased().contains("today") {
                return true
            }
            
            if let parsedDate = formatter.date(from: task.dueDate) {
                return calendar.isDateInToday(parsedDate)
            }
            
            return false
        }
        
        if !dueTodayTasks.isEmpty {
            currentDueTask = dueTodayTasks.removeFirst()
            showDueTodayAlert = true
        }
    }
    
    private func showNextDueTask() {
        showDueTodayAlert = false
        
        if !dueTodayTasks.isEmpty {
            let nextTask = dueTodayTasks.removeFirst()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                currentDueTask = nextTask
                showDueTodayAlert = true
            }
        } else {
            currentDueTask = nil
        }
    }
}

enum AppScreen {
    case home
    case addTask
    case taskDetails
}

#Preview {
    MainMenuView()
}
