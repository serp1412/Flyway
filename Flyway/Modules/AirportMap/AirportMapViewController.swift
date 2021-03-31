import UIKit
import MapKit
import SnapKit

class AirportMapViewController: UIViewController {
    private var map: MKMapView!
    private lazy var viewModel = {
        return AirportMapViewModel(view: self)
    }()
    private var loaderView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
        viewModel.viewDidLoad()
    }
    
    fileprivate func addToMap(_ airports: [Airport]) {
        airports.forEach { airport in
            map.addAnnotation(AirportPoint(airport))
        }
        
        map.zoomOut(on: map.centerCoordinate)
    }
    
    fileprivate func setupMap() {
        map = MKMapView()
        map.delegate = self
        view.addSubview(map)
        map.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension AirportMapViewController: AirportMapView {
    func show(airports: [Airport]) {
        addToMap(airports)
    }
    
    func show(alert: String, subtitle: String?, with retry: @escaping () -> Void) {
        let alert = UIAlertController(title: alert,
                                      message: subtitle,
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(.init(title: "Retry",
                              style: .default,
                              handler: { _ in retry() }))
        
        present(alert, animated: true)
    }
    
    func showLoading() {
        let loaderView = UIView()
        loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        loaderView.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loaderView.appear()
        self.loaderView = loaderView
    }
    
    func hideLoading() {
        loaderView?.dissappear()
    }
}

extension AirportMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let point = view.annotation as? AirportPoint else { return }
        print(point)
    }
}

fileprivate class AirportPoint: MKPointAnnotation {
    let airport: Airport
    
    init(_ airport: Airport) {
        self.airport = airport
        super.init()
        self.coordinate = airport.coordinate
        self.title = airport.name
    }
}

extension MKMapView {
    func zoomOut(on location: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 6371 * 1000 // Earth's radius
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
