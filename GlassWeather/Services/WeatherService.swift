import Foundation

class WeatherService {
    private let apiKey = "YOUR_OPENWEATHERMAP_API_KEY"  // ← ここにAPIキーを入力
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> Weather {
        // APIキーが設定されていないかチェック
        guard apiKey != "YOUR_OPENWEATHERMAP_API_KEY" else {
            throw WeatherError.invalidAPIKey
        }
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = components?.url else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        let apiResponse = try decoder.decode(WeatherAPIResponse.self, from: data)
        
        return convertToWeather(from: apiResponse)
    }
    
    private func convertToWeather(from response: WeatherAPIResponse) -> Weather {
        let weatherInfo = response.weather.first
        let main = response.main
        
        return Weather(
            temperature: main.temp,
            feelsLike: main.feelsLike,
            humidity: main.humidity,
            pressure: main.pressure,
            windSpeed: response.wind.speed,
            visibility: response.visibility,
            condition: weatherInfo?.main ?? "Unknown",
            description: weatherInfo?.description ?? "",
            sunrise: Date(timeIntervalSince1970: response.sys.sunrise),
            sunset: Date(timeIntervalSince1970: response.sys.sunset),
            latitude: response.coord.lat,
            longitude: response.coord.lon
        )
    }
}

enum WeatherError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidAPIKey
    case decodingError
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidAPIKey:
            return "API key not configured. Please set your OpenWeatherMap API key in WeatherService.swift"
        case .decodingError:
            return "Failed to decode response"
        case .networkError:
            return "Network error"
        }
    }
}
