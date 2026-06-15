import Foundation
import CoreLocation

struct Location: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    let city: String
    let country: String
    
    var clLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
