import SwiftUI

struct BackgroundView: View {
    let isDaytime: Bool
    @State private var animate = false
    
    var backgroundColor: [Color] {
        if isDaytime {
            return [
                Color(red: 0.3, green: 0.7, blue: 1.0),
                Color(red: 0.2, green: 0.5, blue: 0.9),
                Color(red: 0.1, green: 0.4, blue: 0.8)
            ]
        } else {
            return [
                Color(red: 0.1, green: 0.15, blue: 0.35),
                Color(red: 0.05, green: 0.1, blue: 0.25),
                Color(red: 0.02, green: 0.05, blue: 0.15)
            ]
        }
    }
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                gradient: Gradient(colors: backgroundColor),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Animated overlay
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.1),
                    Color.white.opacity(0.05)
                ]),
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .animation(
                Animation.easeInOut(duration: 8).repeatForever(autoreverses: true),
                value: animate
            )
            
            // Mesh gradient effect
            VStack {
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .offset(x: -100, y: -100)
                
                Spacer()
                
                Circle()
                    .fill(Color.white.opacity(0.03))
                    .frame(width: 250, height: 250)
                    .offset(x: 100, y: 100)
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    ZStack {
        BackgroundView(isDaytime: true)
        VStack {
            Text("Daytime Background")
                .foregroundColor(.white)
                .font(.headline)
        }
    }
}
