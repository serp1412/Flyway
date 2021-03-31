import CoreLocation

protocol AirportMapView {
    func show(airports: [Airport])
    func show(alert: String,
              subtitle: String?,
              with retry: @escaping () -> Void)
    func showLoading()
    func hideLoading()
}

class AirportMapViewModel {
    fileprivate(set) var view: AirportMapView!
    fileprivate var distances: [AirportDistance] = []
    fileprivate var airports: [Airport] = [] {
        didSet {
            distances = []
            createDistances()
        }
    }
    
    
    init(view: AirportMapView) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchAirports()
    }
    
    func shouldHighlight(airport: Airport) -> Bool {
        guard let longest = distances.last else { return false }
        return longest.first == airport || longest.second == airport
    }
    
    fileprivate func fetchAirports() {
        view.showLoading()
        AppEnvironment.current.api.getAirports { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let airports):
                self.view.show(airports: airports)
                self.airports = airports
            case .failure(let error):
                self.view.show(alert: "Failed to fetch Airports. Try again",
                               subtitle: "Error: \(error.message)",
                               with: self.fetchAirports)
            }
            self.view.hideLoading()
        }
    }
    
    fileprivate func createDistances() {
        airports.enumerated().forEach { index, airport in
            var array = airports
            array.removeSubrange(0...index)
            array.forEach {
                distances.append(.init(first: airport, second: $0))
            }
        }
        
        distances.sort(by:<)
    }
}

fileprivate struct AirportDistance {
    let first: Airport
    let second: Airport
    let distance: Double
    
    init(first: Airport, second: Airport) {
        self.first = first
        self.second = second
        self.distance = first.coordinate.location.distance(from: second.coordinate.location)
    }
}

extension AirportDistance: Comparable {
    static func < (lhs: AirportDistance, rhs: AirportDistance) -> Bool {
        return lhs.distance < rhs.distance
    }
}

extension CLLocationCoordinate2D {
    var location: CLLocation {
        return .init(latitude: latitude, longitude: longitude)
    }
}
