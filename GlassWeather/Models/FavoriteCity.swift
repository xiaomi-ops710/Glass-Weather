import Foundation
import CoreLocation

struct FavoriteCity: Identifiable, Codable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    var addedDate: Date
    
    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double, country: String, addedDate: Date = Date()) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
        self.addedDate = addedDate
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var displayName: String {
        return "\(name), \(country)"
    }
}
