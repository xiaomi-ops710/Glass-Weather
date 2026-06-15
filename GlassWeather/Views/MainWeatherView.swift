import SwiftUI

struct MainWeatherView: View {
    let weather: Weather
    
    var body: some View {
        VStack(spacing: 16) {
            // Weather Icon
            WeatherIcon(condition: weather.condition)
                .font(.system(size: 80))
            
            // Temperature
            VStack(spacing: 8) {
                Text(String(format: "%.0f°", weather.temperature))
                    .font(.system(size: 72, weight: .thin))
                    .foregroundColor(.white)
                
                Text(weather.condition.capitalized)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                
                Text("Feels like \(String(format: "%.0f°", weather.feelsLike))")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(32)
        .background(GlassStyle.glassBackground)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(GlassStyle.glassBorder, lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

#Preview {
    MainWeatherView(weather: Weather.sample)
        .padding()
        .background(LinearGradient(
            gradient: Gradient(colors: [.blue.opacity(0.3), .cyan.opacity(0.2)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
}
