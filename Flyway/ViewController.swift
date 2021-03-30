import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AppEnvironment.current.api.getAirports { result in
            switch result {
            case .success(let airports):
                print(airports)
            case .failure(let error):
                print(error)
            }
        }
        
        AppEnvironment.current.api.getFlights { result in
            switch result {
            case .success(let flights):
                print(flights)
            case .failure(let error):
                print(error)
            }
        }
    }
}

