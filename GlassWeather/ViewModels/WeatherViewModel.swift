import SwiftUI
import CoreLocation

@MainActor
class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentWeather: Weather?
    @Published var locationName: String = "Loading..."
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isDaytime = true
    
    private let weatherService = WeatherService()
    private let locationService = LocationService()
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        setupLocationService()
    }
    
    private func setupLocationService() {
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func requestLocationPermission() {
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            errorMessage = "Location permission denied"
        }
    }
    
    func refreshWeather() async {
        if let location = locationManager.location {
            await fetchWeather(for: location.coordinate)
        }
    }
    
    private func fetchWeather(for coordinate: CLLocationCoordinate2D) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let weather = try await weatherService.fetchWeather(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
            
            self.currentWeather = weather
            self.isDaytime = weather.isDaytime
            await updateLocationName(for: coordinate)
            
        } catch {
            self.errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func updateLocationName(for coordinate: CLLocationCoordinate2D) async {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            if let placemark = placemarks.first {
                let city = placemark.locality ?? "Unknown"
                let country = placemark.country ?? ""
                self.locationName = "\(city), \(country)".trimmingCharacters(in: .whitespaces)
            }
        } catch {
            self.locationName = "Unknown Location"
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
            self.errorMessage = "Location error: \(error.localizedDescription)"
        }
    }
}
