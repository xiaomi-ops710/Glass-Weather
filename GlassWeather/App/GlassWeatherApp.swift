import SwiftUI

@main
struct GlassWeatherApp: App {
    @StateObject private var weatherViewModel = WeatherViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(weatherViewModel)
        }
    }
}
