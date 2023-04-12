import UIKit

protocol LoginFactoryProtocol {
    func getLognCredentialsValidator() -> LoginViewControllerDelegateProtocol
    func getSignUpDelegate() -> SignUpViewControllerDelegateProtocol
    func createLogInViewController(
        coordinator: Coordinatable,
        loginCompletionHandler: @escaping (User) -> Void
    ) -> LogInViewControllerProtocol
}
