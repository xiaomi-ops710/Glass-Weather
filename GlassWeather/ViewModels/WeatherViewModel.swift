import SwiftUI
import CoreLocation

@MainActor
class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentWeather: Weather?
    @Published var locationName: String = "読込中..."
    @Published var isLoading = false
    @Published var isLoadingForecast = false
    @Published var errorMessage: String?
    @Published var isDaytime = true
    @Published var favoriteCities: [FavoriteCity] = []
    @Published var dailyForecasts: [DailyForecast] = []
    
    private let weatherService = WeatherService()
    private let forecastService = ForecastService()
    private let notificationService = NotificationService.shared
    private let storageService = LocalStorageService.shared
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        setupLocationService()
        loadFavoriteCities()
        requestNotificationPermission()
    }
    
    private func setupLocationService() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    private func loadFavoriteCities() {
        favoriteCities = storageService.loadFavorites()
    }
    
    private func requestNotificationPermission() {
        Task {
            let _ = await notificationService.requestPermission()
        }
    }
    
    func requestLocationPermission() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            errorMessage = "位置情報の許可がありません"
        }
    }
    
    func refreshWeather() async {
        if let location = locationManager.location {
            await fetchWeather(for: location.coordinate)
        }
    }
    
    func selectCity(_ city: FavoriteCity) async {
        await fetchWeather(for: city.coordinate)
        storageService.saveLastLocation(city.name, latitude: city.latitude, longitude: city.longitude)
        locationName = city.displayName
    }
    
    func addFavorite(_ city: SearchResultCity) {
        let favoriteCity = FavoriteCity(
            name: city.city,
            latitude: city.latitude,
            longitude: city.longitude,
            country: city.country
        )
        storageService.addFavorite(favoriteCity)
        loadFavoriteCities()
    }
    
    func removeFavorite(withId id: UUID) {
        storageService.removeFavorite(withId: id)
        loadFavoriteCities()
    }
    
    private func fetchWeather(for coordinate: CLLocationCoordinate2D) async {
        isLoading = true
        isLoadingForecast = true
        errorMessage = nil
        
        do {
            let weather = try await weatherService.fetchWeather(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            
            self.currentWeather = weather
            self.isDaytime = weather.isDaytime
            await updateLocationName(for: coordinate)
            
            // Send notification if needed
            notificationService.sendWeatherAlert(weather: weather)
            
            // Fetch forecast
            await fetchForecast(for: coordinate)
            
        } catch {
            self.errorMessage = "天気情報の取得に失敗しました: \(error.localizedDescription)"
        }
        
        isLoading = false
        isLoadingForecast = false
    }
    
    private func fetchForecast(for coordinate: CLLocationCoordinate2D) async {
        do {
            self.dailyForecasts = try await forecastService.fetchFiveDayForecast(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        } catch {
            print("Forecast error: \(error)")
        }
    }
    
    private func updateLocationName(for coordinate: CLLocationCoordinate2D) async {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            if let placemark = placemarks.first {
                let city = placemark.locality ?? "不明"
                let country = placemark.country ?? ""
                self.locationName = "\(city), \(country)".trimmingCharacters(in: .whitespaces)
                storageService.saveLastLocation(city, latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
        } catch {
            self.locationName = "不明な場所"
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        Task { @MainActor in
            await fetchWeather(for: location.coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.errorMessage = "位置情報エラー: \(error.localizedDescription)"
        }
    }
}
