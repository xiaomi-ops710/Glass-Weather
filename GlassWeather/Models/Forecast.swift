import Foundation

struct DailyForecast: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let tempMax: Double
    let tempMin: Double
    let condition: String
    let description: String
    let humidity: Int
    let precipitationProbability: Double
    let windSpeed: Double
    
    var dayName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    var dayDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter.string(from: date)
    }
}

struct HourlyForecast: Identifiable, Codable {
    let id = UUID()
    let time: Date
    let temperature: Double
    let condition: String
    let windSpeed: Double
    let precipitation: Double
    
    var hourString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: time)
    }
}
