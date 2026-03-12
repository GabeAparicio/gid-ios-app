import SwiftUI

struct MainMenuView: View {
    
    @State private var showMenu = false
    @State private var selectedScreen: AppScreen = .home
    @StateObject private var appData = AppData()
    
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
