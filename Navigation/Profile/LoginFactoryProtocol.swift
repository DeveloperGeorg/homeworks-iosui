import UIKit

protocol LoginFactoryProtocol {
    func getLognCredentialsValidator() -> LoginViewControllerDelegateProtocol
    func getSignUpDelegate() -> SignUpViewControllerDelegateProtocol
    func createLogInViewController(coordinator: ProfileCoordinator) -> UIViewController
    func createLoginError(title: String, message: String) -> UIAlertController
}
