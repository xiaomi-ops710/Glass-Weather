import Foundation

class LocalStorageService {
    static let shared = LocalStorageService()
    
    private let favoritesKey = "favoritesCities"
    private let searchHistoryKey = "searchHistory"
    private let lastLocationKey = "lastLocation"
    private let notificationSettingsKey = "notificationSettings"
    
    // MARK: - Favorite Cities
    
    func saveFavorites(_ cities: [FavoriteCity]) {
        if let encoded = try? JSONEncoder().encode(cities) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    func loadFavorites() -> [FavoriteCity] {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([FavoriteCity].self, from: data) {
            return decoded
        }
        return []
    }
    
    func addFavorite(_ city: FavoriteCity) {
        var favorites = loadFavorites()
        if !favorites.contains(where: { $0.id == city.id }) {
            favorites.append(city)
            saveFavorites(favorites)
        }
    }
    
    func removeFavorite(withId id: UUID) {
        var favorites = loadFavorites()
        favorites.removeAll { $0.id == id }
        saveFavorites(favorites)
    }
    
    // MARK: - Search History
    
    func saveSearchHistory(_ history: [SearchHistoryItem]) {
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: searchHistoryKey)
        }
    }
    
    func loadSearchHistory() -> [SearchHistoryItem] {
        if let data = UserDefaults.standard.data(forKey: searchHistoryKey),
           let decoded = try? JSONDecoder().decode([SearchHistoryItem].self, from: data) {
            return decoded
        }
        return []
    }
    
    func addSearchHistory(_ item: SearchHistoryItem) {
        var history = loadSearchHistory()
        
        if let index = history.firstIndex(where: { $0.city == item.city && $0.country == item.country }) {
            history[index].searchDate = Date()
            history[index].searchCount += 1
        } else {
            history.insert(item, at: 0)
        }
        
        if history.count > 50 {
            history = Array(history.prefix(50))
        }
        
        saveSearchHistory(history)
    }
    
    func clearSearchHistory() {
        UserDefaults.standard.removeObject(forKey: searchHistoryKey)
    }
    
    // MARK: - Last Location
    
    func saveLastLocation(_ city: String, latitude: Double, longitude: Double) {
        let lastLocation: [String: Any] = [
            "city": city,
            "latitude": latitude,
            "longitude": longitude,
            "date": Date()
        ]
        UserDefaults.standard.set(lastLocation, forKey: lastLocationKey)
    }
    
    func loadLastLocation() -> (city: String, latitude: Double, longitude: Double)? {
        if let lastLocation = UserDefaults.standard.dictionary(forKey: lastLocationKey),
           let city = lastLocation["city"] as? String,
           let latitude = lastLocation["latitude"] as? Double,
           let longitude = lastLocation["longitude"] as? Double {
            return (city, latitude, longitude)
        }
        return nil
    }
    
    // MARK: - Notification Settings
    
    func saveNotificationSettings(_ settings: NotificationSettings) {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: notificationSettingsKey)
        }
    }
    
    func loadNotificationSettings() -> NotificationSettings {
        if let data = UserDefaults.standard.data(forKey: notificationSettingsKey),
           let decoded = try? JSONDecoder().decode(NotificationSettings.self, from: data) {
            return decoded
        }
        return NotificationSettings()
    }
}

struct NotificationSettings: Codable {
    var isEnabled: Bool = true
    var notifyOnRain: Bool = true
    var notifyOnStorm: Bool = true
    var notifyOnExtremeCold: Bool = true
    var notifyOnExtremeHeat: Bool = true
    var temperatureThresholdCold: Double = 0
    var temperatureThresholdHeat: Double = 35
}
