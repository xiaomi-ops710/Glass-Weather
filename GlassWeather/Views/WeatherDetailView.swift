import SwiftUI

struct WeatherDetailView: View {
    let weather: Weather
    
    var body: some View {
        VStack(spacing: 12) {
            // Humidity
            DetailRow(
                icon: "humidity.fill",
                label: "Humidity",
                value: "\(weather.humidity)%"
            )
            
            Divider()
                .opacity(0.3)
            
            // Wind Speed
            DetailRow(
                icon: "wind",
                label: "Wind Speed",
                value: String(format: "%.1f m/s", weather.windSpeed)
            )
            
            Divider()
                .opacity(0.3)
            
            // Pressure
            DetailRow(
                icon: "gauge",
                label: "Pressure",
                value: "\(weather.pressure) hPa"
            )
            
            Divider()
                .opacity(0.3)
            
            // Visibility
            DetailRow(
                icon: "eye.fill",
                label: "Visibility",
                value: String(format: "%.1f km", weather.visibility / 1000)
            )
        }
        .padding(24)
        .background(GlassStyle.glassBackground)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(GlassStyle.glassBorder, lineWidth: 1.5)
        )
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
    }
}

struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 30)
                
                Text(label)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    WeatherDetailView(weather: Weather.sample)
        .padding()
        .background(LinearGradient(
            gradient: Gradient(colors: [.blue.opacity(0.3), .cyan.opacity(0.2)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
}
