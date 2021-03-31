protocol AirportMapView {
    func show(airports: [Airport])
    func show(alert: String,
              subtitle: String?,
              with retry: @escaping () -> Void)
    func showLoading()
    func hideLoading()
}

class AirportMapViewModel {
    var view: AirportMapView!
    
    init(view: AirportMapView) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchAirports()
    }
    
    fileprivate func fetchAirports() {
        view.showLoading()
        AppEnvironment.current.api.getAirports { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let airports):
                self.view.show(airports: airports)
            case .failure(let error):
                self.view.show(alert: "Failed to fetch Airports. Try again",
                               subtitle: "Error: \(error.message)",
                               with: self.fetchAirports)
            }
            self.view.hideLoading()
        }
    }
}
