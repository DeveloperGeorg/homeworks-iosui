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
}
