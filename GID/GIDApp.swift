import SwiftUI

@main
struct GIDApp: App {
    
    init() {
        NotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashContainerView()
        }
    }
}
