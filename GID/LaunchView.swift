import SwiftUI

struct LaunchView: View {
    
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
                
                Spacer()
                
                Text("GID!")
                    .font(.custom("BlackOpsOne-Regular", size: 72))
                    .foregroundColor(.white)
                
                Text("GET IT DONE!")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 8)
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("Gabriel Aparicio")
                    Text("Wassn Al Nabhan")
                }
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.bottom, 36)
            }
        }
    }
}

#Preview {
    LaunchView()
}
