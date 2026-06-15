import SwiftUI

struct BackgroundView: View {
    let isDaytime: Bool
    let weatherCondition: String = ""
    @State private var animate = false
    
    var backgroundColor: [Color] {
        let condition = weatherCondition.lowercased()
        
        if condition.contains("rain") || condition.contains("drizzle") {
            return [
                Color(red: 0.2, green: 0.3, blue: 0.5),
                Color(red: 0.15, green: 0.2, blue: 0.4)
            ]
        } else if condition.contains("thunder") || condition.contains("storm") {
            return [
                Color(red: 0.1, green: 0.1, blue: 0.3),
                Color(red: 0.05, green: 0.05, blue: 0.2)
            ]
        } else if condition.contains("snow") {
            return [
                Color(red: 0.4, green: 0.4, blue: 0.5),
                Color(red: 0.3, green: 0.3, blue: 0.4)
            ]
        } else if condition.contains("cloud") {
            return [
                Color(red: 0.25, green: 0.4, blue: 0.6),
                Color(red: 0.15, green: 0.3, blue: 0.5)
            ]
        } else if isDaytime {
            return [
                Color(red: 0.3, green: 0.7, blue: 1.0),
                Color(red: 0.2, green: 0.5, blue: 0.9)
            ]
        } else {
            return [
                Color(red: 0.1, green: 0.15, blue: 0.35),
                Color(red: 0.05, green: 0.1, blue: 0.25)
            ]
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: backgroundColor),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
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
        BackgroundView(isDaytime: true, weatherCondition: "Rainy")
        VStack {
            Text("雨の背景")
                .foregroundColor(.white)
                .font(.headline)
        }
    }
}
