import Foundation

// MARK: - API Response Models

struct WeatherAPIResponse: Codable {
    let coord: Coordinates
    let weather: [WeatherInfo]
    let main: MainInfo
    let visibility: Double
    let wind: WindInfo
    let sys: SystemInfo
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case coord, weather, main, visibility, wind, sys, name
    }
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct WeatherInfo: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainInfo: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

struct WindInfo: Codable {
    let speed: Double
    let deg: Int?
    let gust: Double?
}

struct SystemInfo: Codable {
    let sunrise: TimeInterval
    let sunset: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case sunrise, sunset
    }
}
