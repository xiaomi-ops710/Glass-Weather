import Foundation

struct Weather: Identifiable {
    let id = UUID()
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let visibility: Double
    let condition: String
    let description: String
    let sunrise: Date
    let sunset: Date
    let latitude: Double
    let longitude: Double
    
    var isDaytime: Bool {
        let now = Date()
        return now >= sunrise && now < sunset
    }
    
    static let sample = Weather(
        temperature: 22.5,
        feelsLike: 21.0,
        humidity: 65,
        pressure: 1013,
        windSpeed: 3.5,
        visibility: 10000,
        condition: "Partly Cloudy",
        description: "Partly cloudy sky",
        sunrise: Date().addingTimeInterval(-3600),
        sunset: Date().addingTimeInterval(3600 * 8),
        latitude: 35.6762,
        longitude: 139.6503
    )
}
