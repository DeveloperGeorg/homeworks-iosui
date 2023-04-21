import UIKit

protocol Coordinatable: AnyObject {
    var childCoordinators: [Coordinatable] { get set}
    var navigationController: UINavigationController { get set }
    
    func start()
}

extension Coordinatable {
    
    func createError(title: String, message: String) -> UIAlertController {
        var alertMessage = String(localized: "Invalid login or password.")
        if message != "" {
            alertMessage = message
        }
        var alertTitle = String(localized: "Error")
        if title != "" {
            alertTitle = title
        }
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: String(localized: "OK"), style: .default) {
            UIAlertAction in
        }
        alert.addAction(okAction)
        return alert
    }
    
    func showError(title: String, message: String) {
        let alert = self.createError(title: title, message: message)
        navigationController.present(alert, animated: true, completion: nil)
    }
}
