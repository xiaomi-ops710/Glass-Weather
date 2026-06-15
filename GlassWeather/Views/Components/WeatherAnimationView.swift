import SwiftUI

struct WeatherAnimationView: View {
    let condition: String
    @State private var animate = false
    @State private var drops: [RainDrop] = []
    @State private var snowflakes: [Snowflake] = []
    @State private var clouds: [CloudParticle] = []
    
    var body: some View {
        ZStack {
            if condition.lowercased().contains("rain") || condition.lowercased().contains("drizzle") {
                RainAnimationView(drops: $drops)
            } else if condition.lowercased().contains("snow") {
                SnowAnimationView(snowflakes: $snowflakes)
            } else if condition.lowercased().contains("cloud") {
                CloudAnimationView(clouds: $clouds)
            } else if condition.lowercased().contains("thunder") || condition.lowercased().contains("storm") {
                ThunderAnimationView()
            }
        }
        .onAppear {
            animate = true
            generateParticles()
        }
    }
    
    private func generateParticles() {
        if condition.lowercased().contains("rain") || condition.lowercased().contains("drizzle") {
            drops = (0..<50).map { _ in RainDrop() }
        } else if condition.lowercased().contains("snow") {
            snowflakes = (0..<30).map { _ in Snowflake() }
        } else if condition.lowercased().contains("cloud") {
            clouds = (0..<5).map { _ in CloudParticle() }
        }
    }
}

struct RainDrop: Identifiable {
    let id = UUID()
    let x = Double.random(in: 0...400)
    var y = Double.random(in: -50...800)
    let speed = Double.random(in: 2...8)
    let opacity = Double.random(in: 0.3...0.8)
}

struct RainAnimationView: View {
    @Binding var drops: [RainDrop]
    @State private var animationTimer: Timer?
    
    var body: some View {
        ZStack {
            ForEach(0..<drops.count, id: \.self) { index in
                VStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(drops[index].opacity))
                        .frame(width: 2, height: 15)
                    Spacer()
                }
                .offset(x: drops[index].x, y: drops[index].y)
            }
        }
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            animationTimer?.invalidate()
        }
    }
    
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            for i in 0..<drops.count {
                drops[i].y += drops[i].speed
                if drops[i].y > 800 {
                    drops[i].y = -50
                }
            }
        }
    }
}

struct Snowflake: Identifiable {
    let id = UUID()
    var x: Double
    let baseX: Double
    let speed = Double.random(in: 0.5...2)
    let sway = Double.random(in: -2...2)
    var y: Double
    let size = Double.random(in: 4...12)
    
    init() {
        let baseX = Double.random(in: 0...400)
        self.baseX = baseX
        self.x = baseX
        self.y = Double.random(in: -50...800)
    }
}

struct SnowAnimationView: View {
    @Binding var snowflakes: [Snowflake]
    @State private var animationTimer: Timer?
    
    var body: some View {
        ZStack {
            ForEach(0..<snowflakes.count, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: snowflakes[index].size, height: snowflakes[index].size)
                    .offset(x: snowflakes[index].x, y: snowflakes[index].y)
                    .blur(radius: 0.5)
            }
        }
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            animationTimer?.invalidate()
        }
    }
    
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            for i in 0..<snowflakes.count {
                snowflakes[i].y += snowflakes[i].speed
                snowflakes[i].x = snowflakes[i].baseX + sin(snowflakes[i].y / 50) * 30 + snowflakes[i].sway
                
                if snowflakes[i].y > 800 {
                    snowflakes[i].y = -50
                    snowflakes[i].x = Double.random(in: 0...400)
                }
            }
        }
    }
}

struct CloudParticle: Identifiable {
    let id = UUID()
    let x = Double.random(in: 0...400)
    let y = Double.random(in: 0...600)
    let size = Double.random(in: 20...60)
    let speed = Double.random(in: 0.1...0.3)
}

struct CloudAnimationView: View {
    @Binding var clouds: [CloudParticle]
    @State private var offsets: [Double] = []
    @State private var animationTimer: Timer?
    
    var body: some View {
        ZStack {
            ForEach(0..<clouds.count, id: \.self) { index in
                Image(systemName: "cloud.fill")
                    .font(.system(size: clouds[index].size))
                    .foregroundColor(.white.opacity(0.3))
                    .offset(x: clouds[index].x + (offsets.indices.contains(index) ? offsets[index] : 0), y: clouds[index].y)
            }
        }
        .onAppear {
            offsets = Array(repeating: 0, count: clouds.count)
            startAnimation()
        }
        .onDisappear {
            animationTimer?.invalidate()
        }
    }
    
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
            for i in 0..<offsets.count {
                offsets[i] += clouds[i].speed
                if offsets[i] > 400 {
                    offsets[i] = -clouds[i].size
                }
            }
        }
    }
}

struct ThunderAnimationView: View {
    @State private var showLightning = false
    @State private var lightningTimer: Timer?
    
    var body: some View {
        ZStack {
            if showLightning {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.yellow.opacity(0.6),
                            Color.white.opacity(0.4)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
                .ignoresSafeArea()
                .transition(.opacity)
            }
        }
        .onAppear {
            startLightningAnimation()
        }
        .onDisappear {
            lightningTimer?.invalidate()
        }
    }
    
    private func startLightningAnimation() {
        lightningTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 1...4), repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.1)) {
                showLightning = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    showLightning = false
                }
            }
        }
    }
}

#Preview {
    WeatherAnimationView(condition: "Rainy")
}
