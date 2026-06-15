import SwiftUI

struct WeatherIcon: View {
    let condition: String
    
    var iconName: String {
        let lowercased = condition.lowercased()
        
        switch lowercased {
        case let s where s.contains("rain"):
            return "cloud.rain.fill"
        case let s where s.contains("clear") || s.contains("sunny"):
            return "sun.max.fill"
        case let s where s.contains("cloud"):
            return "cloud.fill"
        case let s where s.contains("snow"):
            return "snow"
        case let s where s.contains("thunder") || s.contains("storm"):
            return "cloud.bolt.rain.fill"
        case let s where s.contains("wind"):
            return "wind"
        case let s where s.contains("fog") || s.contains("mist"):
            return "cloud.fog.fill"
        case let s where s.contains("haze"):
            return "sun.haze.fill"
        default:
            return "sun.max.fill"
        }
    }
    
    var iconColor: Color {
        let lowercased = condition.lowercased()
        
        switch lowercased {
        case let s where s.contains("rain") || s.contains("thunder"):
            return Color(red: 0.4, green: 0.6, blue: 0.9)
        case let s where s.contains("snow"):
            return .white
        case let s where s.contains("clear") || s.contains("sunny"):
            return Color(red: 1.0, green: 0.84, blue: 0.0)
        default:
            return Color(red: 0.9, green: 0.9, blue: 1.0)
        }
    }
    
    var body: some View {
        Image(systemName: iconName)
            .foregroundColor(iconColor)
    }
}

#Preview {
    HStack {
        WeatherIcon(condition: "Sunny")
        WeatherIcon(condition: "Rainy")
        WeatherIcon(condition: "Cloudy")
        WeatherIcon(condition: "Snow")
    }
    .font(.system(size: 60))
    .padding()
    .background(LinearGradient(
        gradient: Gradient(colors: [.blue.opacity(0.3), .cyan.opacity(0.2)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    ))
}
