import SwiftUI

struct SplashContainerView: View {
    
    @State private var showLaunch = true
    
    var body: some View {
        Group {
            if showLaunch {
                LaunchView()
            } else {
                MainMenuView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showLaunch = false
                }
            }
        }
    }
}

#Preview {
    SplashContainerView()
}
