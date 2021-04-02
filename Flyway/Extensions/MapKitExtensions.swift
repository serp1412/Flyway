import MapKit

extension MKMapView {
    func zoom(on location: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: radius,
                                                  longitudinalMeters: radius)
        setRegion(coordinateRegion, animated: true)
    }
}

extension CLLocationCoordinate2D {
    func distance(from coordinate: CLLocationCoordinate2D) -> Double {
        return location.distance(from: coordinate.location)
    }
}

extension CLLocationCoordinate2D {
    var location: CLLocation {
        return .init(latitude: latitude, longitude: longitude)
    }
}

extension Double {
    var display: String {
        return "\(Int(self / 1000))km"
    }
}
