import UIKit

protocol LoginFactoryProtocol {
    func getLognCredentialsValidator() -> LoginViewControllerDelegateProtocol
    func getSignUpDelegate() -> SignUpViewControllerDelegateProtocol
    func createLogInViewController(coordinator: ProfileCoordinator) -> LogInViewControllerProtocol
}
