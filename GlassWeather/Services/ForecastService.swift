import Foundation

class ForecastService {
    private let apiKey = "YOUR_OPENWEATHERMAP_API_KEY"
    private let baseURL = "https://api.openweathermap.org/data/2.5/forecast"
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    func fetchFiveDayForecast(latitude: Double, longitude: Double) async throws -> [DailyForecast] {
        guard apiKey != "YOUR_OPENWEATHERMAP_API_KEY" else {
            throw WeatherError.invalidAPIKey
        }
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "cnt", value: "40")
        ]
        
        guard let url = components?.url else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        let apiResponse = try decoder.decode(ForecastAPIResponse.self, from: data)
        return convertToDailyForecasts(from: apiResponse)
    }
    
    private func convertToDailyForecasts(from response: ForecastAPIResponse) -> [DailyForecast] {
        var dailyForecasts: [String: [ForecastItem]] = [:]
        
        for item in response.list {
            let date = Date(timeIntervalSince1970: item.dt)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dayKey = formatter.string(from: date)
            
            if dailyForecasts[dayKey] == nil {
                dailyForecasts[dayKey] = []
            }
            dailyForecasts[dayKey]?.append(item)
        }
        
        var forecasts: [DailyForecast] = []
        
        for (_, items) in dailyForecasts.sorted(by: { $0.key < $1.key }).prefix(5) {
            let temperatures = items.map { $0.main.temp }
            let tempMax = temperatures.max() ?? 0
            let tempMin = temperatures.min() ?? 0
            let humidity = Int(items.map { Double($0.main.humidity) }.reduce(0, +) / Double(items.count))
            let windSpeed = items.map { $0.wind.speed }.reduce(0, +) / Double(items.count)
            let precipitation = items.map { $0.pop }.reduce(0, +) / Double(items.count)
            
            let condition = items.first?.weather.first?.main ?? "Unknown"
            let description = items.first?.weather.first?.description ?? ""
            
            if let date = items.first.map({ Date(timeIntervalSince1970: $0.dt) }).first {
                let forecast = DailyForecast(
                    date: date,
                    tempMax: tempMax,
                    tempMin: tempMin,
                    condition: condition,
                    description: description,
                    humidity: humidity,
                    precipitationProbability: precipitation * 100,
                    windSpeed: windSpeed
                )
                forecasts.append(forecast)
            }
        }
        
        return forecasts
    }
}

struct ForecastAPIResponse: Codable {
    let list: [ForecastItem]
}

struct ForecastItem: Codable {
    let dt: TimeInterval
    let main: MainInfo
    let weather: [WeatherInfo]
    let wind: WindInfo
    let pop: Double
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind, pop
    }
}
