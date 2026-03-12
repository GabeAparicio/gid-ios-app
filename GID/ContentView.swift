import SwiftUI

struct ContentView: View {
    
    @Binding var showMenu: Bool
    @Binding var selectedScreen: AppScreen
    @ObservedObject var appData: AppData
    
    let columns = [GridItem(), GridItem()]
    
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
                
                Spacer()
                
                LazyVGrid(columns: columns, spacing: 28) {
                    ForEach(appData.tasks) { task in
                        Button(action: {
                            appData.selectedTask = task
                            selectedScreen = .taskDetails
                        }) {
                            TaskCard(task: task)
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                Text("GID!")
                    .font(.custom("BlackOpsOne-Regular", size: 18))
                    .foregroundColor(.white.opacity(0.75))
                    .padding(.bottom, 16)
            }
        }
    }
}

struct TaskCard: View {
    
    var task: Task
    
    var body: some View {
        VStack(spacing: 8) {
            Text(task.title)
                .font(.system(size: 15, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            Text("Due: \(task.dueDate)")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.black.opacity(0.85))
            
            Text("Priority: \(task.priority)")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.black.opacity(0.85))
        }
        .frame(width: 145, height: 112)
        .background(Color.white.opacity(0.95))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (255, 255, 255)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

#Preview {
    ContentView(
        showMenu: .constant(false),
        selectedScreen: .constant(.home),
        appData: AppData()
    )
}
