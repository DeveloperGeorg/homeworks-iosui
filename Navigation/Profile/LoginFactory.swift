import UIKit

class LoginFactory: LoginFactoryProtocol {
    func getLognCredentialsValidator() -> LoginViewControllerDelegateProtocol {
        return LoginInspector()
    }
    func getSignUpDelegate() -> SignUpViewControllerDelegateProtocol {
        return LoginInspector()
    }
    func createLogInViewController(coordinator: ProfileCoordinator) -> UIViewController {
        return LogInViewController(
            loginViewControllerDelegate: self.getLognCredentialsValidator(),
            signUpViewControllerDelegate: self.getSignUpDelegate(),
            coordinator: coordinator
        )
    }
    func createLoginError(title: String, message: String) -> UIAlertController {
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
}
