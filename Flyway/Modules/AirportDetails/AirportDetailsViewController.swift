import UIKit
import SnapKit
import MapKit
import CoreLocation

class AirportDetailsViewController: UIViewController {
    let airport: Airport
    let closestAirport: Airport
    
    init(airport: Airport, closestAirport: Airport) {
        self.airport = airport
        self.closestAirport = closestAirport
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stackView = setupStackView()
        let button = closeButton()
        
        stackView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(button.snp.top)
        }
    }
    
    fileprivate func setupStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        view.backgroundColor = .white
        view.addSubview(stackView)
        let map = setupMap()
        map.zoom(on: airport.coordinate, radius: 4000)
        stackView.addArrangedSubview(map)
        stackView.addArrangedSubview(createLabel(withPrefix: "ID",
                                                 text: airport.id))
        stackView.addArrangedSubview(createLabel(withPrefix: "Name",
                                                 text: airport.name))
        stackView.addArrangedSubview(createLabel(withPrefix: "City",
                                                 text: airport.city))
        stackView.addArrangedSubview(createLabel(withPrefix: "Country",
                                                 text: airport.countryId))
        stackView.addArrangedSubview(createLabel(withPrefix: "Latitude",
                                                 text: "\(airport.coordinate.latitude)"))
        stackView.addArrangedSubview(createLabel(withPrefix: "Longitude",
                                                 text: "\(airport.coordinate.longitude)"))
        stackView.addArrangedSubview(createLabel(withPrefix: "Nearest Airport",
                                                 text: "\(closestAirport.name)"))
        let distance = airport.coordinate.distance(from: closestAirport.coordinate)
        stackView.addArrangedSubview(createLabel(withPrefix: "Distance",
                                                 text: distance.display))
        stackView.addArrangedSubview(UIView())
        
        return stackView
    }
    
    fileprivate func setupMap() -> MKMapView {
        let map = MKMapView()
        map.isUserInteractionEnabled = false
        let point = MKPointAnnotation()
        point.coordinate = airport.coordinate
        map.addAnnotation(point)
        map.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        
        return map
    }
    
    fileprivate func closeButton() -> UIButton {
        let button = UIButton(type: .system, primaryAction: .init(handler: { _ in
            self.dismiss(animated: true)
        }))
        button.setTitle("Close", for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(44)
        }
        
        return button
    }
    
    fileprivate func createLabel(withPrefix prefix: String, text: String) -> UIView {
        let view = UIView()
        let label = UILabel()
        view.addSubview(label)
        label.text = "\(prefix): \(text)"
        label.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
        }
        
        return view
    }
}
