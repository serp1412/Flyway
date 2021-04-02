import UIKit
import ObjectiveC

extension UIView {
    func appear() {
        toggleVisibility(true)
    }
    
    func dissappear() {
        toggleVisibility(false)
    }
    
    fileprivate func toggleVisibility(_ visible: Bool) {
        alpha = visible ? 0 : 1
        UIView.animate(withDuration: 0.2) {
            self.alpha = visible ? 1 : 0
        }
    }
}

protocol RetryDisplayable: UIViewController {
    func show(alert: String, subtitle: String?, with retry: @escaping () -> Void)
}

extension RetryDisplayable  {
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
}

protocol Loadable: UIViewController {
    func showLoading()
    func hideLoading()
}

var AssociatedObjectHandle: UInt8 = 0

extension Loadable {
    var loader: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
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
        loader = loaderView
    }
    
    func hideLoading() {
        loader?.dissappear()
    }
}
