import CoreLocation

struct Airport: Codable, Equatable {
    let id: String
    let name: String
    let city: String
    let countryId: String
    private let latitude: Double
    private let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        return .init(latitude: latitude, longitude: longitude)
    }
}

//{
//     "id": "AUS",
//     "latitude": 30.202545,
//     "longitude": -97.66706,
//     "name": "Austin-Bergstrom International Airport",
//     "city": "Austin",
//     "countryId": "US"
//   },
