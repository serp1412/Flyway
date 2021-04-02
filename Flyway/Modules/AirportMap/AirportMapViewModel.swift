import CoreLocation

protocol AirportDisplayView: RetryDisplayable & Loadable {
    func show(airports: [Airport])
}

class AirportMapViewModel {
    fileprivate(set) var view: AirportDisplayView!
    fileprivate var distances: [AirportDistance] = []
    fileprivate var airports: [Airport] = [] {
        didSet {
            distances = []
            createDistances()
        }
    }
    
    
    init(view: AirportDisplayView) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchAirports()
    }
    
    func shouldHighlight(airport: Airport) -> Bool {
        guard let longest = distances.last else { return false }
        return longest.first == airport || longest.second == airport
    }
    
    func closestAirport(to airport: Airport) -> Airport {
        let distance = distances.filter { distance in
            return distance.first == airport || distance.second == airport
        }.sorted(by: <).first
        
        guard let unWrappedDistance = distance else { return airport }
        
        return unWrappedDistance.first == airport
            ? unWrappedDistance.second
            : unWrappedDistance.first
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
