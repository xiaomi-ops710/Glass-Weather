import Foundation
import CoreLocation

class CitySearchService {
    private let geocoder = CLGeocoder()
    
    func searchCities(query: String) async throws -> [SearchResultCity] {
        let results = try await geocoder.geocodeAddressString(query)
        
        return results.compactMap { placemark -> SearchResultCity? in
            guard let location = placemark.location else { return nil }
            
            let city = placemark.locality ?? placemark.subAdministrativeArea ?? placemark.administrativeArea ?? "Unknown"
            let country = placemark.country ?? "Unknown"
            
            return SearchResultCity(
                city: city,
                country: country,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        }
    }
}

struct SearchResultCity: Identifiable {
    let id = UUID()
    let city: String
    let country: String
    let latitude: Double
    let longitude: Double
    
    var displayName: String {
        return "\(city), \(country)"
    }
}
