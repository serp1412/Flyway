import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBar = UITabBarController()
        let airportVC = AirportMapViewController()
        airportVC.tabBarItem = UITabBarItem(title: "Airports", image: UIImage(systemName: "house"), tag: 0)
        let flightsVC = FlightsViewController()
        flightsVC.tabBarItem = UITabBarItem(title: "Flights", image: UIImage(systemName: "star"), tag: 1)
        tabBar.setViewControllers([airportVC, flightsVC], animated: false)
         
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
        window?.windowScene = windowScene
    }
}
