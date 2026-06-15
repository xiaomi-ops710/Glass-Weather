import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    private let storageService = LocalStorageService.shared
    
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }
    
    func sendWeatherAlert(weather: Weather) {
        let settings = storageService.loadNotificationSettings()
        
        guard settings.isEnabled else { return }
        
        var shouldNotify = false
        var title = ""
        var body = ""
        
        let condition = weather.condition.lowercased()
        
        if settings.notifyOnRain && (condition.contains("rain") || condition.contains("drizzle")) {
            shouldNotify = true
            title = "🌧️ 雨が降っています"
            body = "現在の天気: \(weather.condition)。傘を持つことをお勧めします。"
        }
        
        if settings.notifyOnStorm && (condition.contains("thunder") || condition.contains("storm")) {
            shouldNotify = true
            title = "⚡ 雷雨警報"
            body = "⚠️ 雷雨が発生しています。安全な場所に移動してください。"
        }
        
        if settings.notifyOnExtremeCold && weather.temperature < settings.temperatureThresholdCold {
            shouldNotify = true
            title = "❄️ 極寒警報"
            body = "気温が\(String(format: "%.1f", weather.temperature))°Cまで低下しています。暖かい服装をしてください。"
        }
        
        if settings.notifyOnExtremeHeat && weather.temperature > settings.temperatureThresholdHeat {
            shouldNotify = true
            title = "🌡️ 熱中症警報"
            body = "気温が\(String(format: "%.1f", weather.temperature))°Cに達しています。水分補給と休息を心がけてください。"
        }
        
        if shouldNotify {
            scheduleNotification(title: title, body: body)
        }
    }
    
    private func scheduleNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
