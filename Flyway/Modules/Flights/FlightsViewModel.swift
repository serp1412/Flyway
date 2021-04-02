import Foundation
import CoreLocation

class FlightsViewModel {
    fileprivate(set) var view: AirportDisplayView!
    fileprivate let amsCoordinate = CLLocationCoordinate2D(latitude: 52.30907,
                                                           longitude: 4.763385)
    fileprivate var airports: [Airport] = []
    fileprivate var error: APIError?
    fileprivate var distances: [Airport: Double] = [:]
    
    init(view: AirportDisplayView) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchAirports()
    }
    
    func distanceToAms(from airport: Airport) -> Double {
        return distances[airport] ?? airport.coordinate.distance(from: amsCoordinate)
    }
    
    fileprivate func fetchAirports() {
        self.view.showLoading()
        let group = DispatchGroup()
        
        var allAirports: [Airport] = []
        var flights: [Flight] = []
        
        execute(callback: AppEnvironment.current.api.getAirports,
                group: group) {
            allAirports = $0
        }
        
        execute(callback: AppEnvironment.current.api.getFlights,
                group: group) {
            flights = $0
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.view.hideLoading()
            
            if let error = self.error {
                self.view.show(alert: "Something went wrong",
                               subtitle: error.message,
                               with: self.fetchAirports)
            } else {
                self.airports = self.filter(allAirports: allAirports, with: flights)
                self.view.show(airports: self.airports)
            }
        }
    }
    
    fileprivate func filter(allAirports: [Airport], with flights: [Flight]) -> [Airport] {
        let amsAirports = flights.compactMap({ flight in
            allAirports.first { airport in
                airport.id == flight.arrivalAirportId
            }
        }).toSet()
        
        let airports = amsAirports.toArray().sorted(by: { first, second in
            let firstDistance = first.coordinate.distance(from: amsCoordinate)
            let secondDistance = second.coordinate.distance(from: amsCoordinate)
            distances[first] = firstDistance
            distances[second] = secondDistance
            
            return firstDistance < secondDistance
        })
        
        return airports
    }
    
    fileprivate func execute<R>(callback: (@escaping (Result<R, APIError>) -> ()) -> (),
                                group: DispatchGroup,
                                handler: @escaping (R) -> ()) {
        group.enter()
        callback() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                handler(data)
            case .failure(let error):
                self.error = error
            }
            group.leave()
        }
    }
}

extension Array where Element: Hashable {
    func toSet() -> Set<Element> {
        return Set(self)
    }
}


extension Set {
    func toArray() -> Array<Element> {
        return Array(self)
    }
}
