import UIKit

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
