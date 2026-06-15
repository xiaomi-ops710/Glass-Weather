import Foundation

struct SearchHistoryItem: Identifiable, Codable {
    let id: UUID
    let city: String
    let country: String
    let latitude: Double
    let longitude: Double
    var searchDate: Date
    var searchCount: Int = 1
    
    init(id: UUID = UUID(), city: String, country: String, latitude: Double, longitude: Double, searchDate: Date = Date(), searchCount: Int = 1) {
        self.id = id
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.searchDate = searchDate
        self.searchCount = searchCount
    }
    
    var displayName: String {
        return "\(city), \(country)"
    }
}
