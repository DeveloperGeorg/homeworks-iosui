import UIKit

final class ProfileCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let loginFactory = LoginFactory()
        self.navigationController.setViewControllers([LogInViewController(
                                                        loginViewControllerDelegate: loginFactory.getLognCredentialsValidator(),
                                                        signUpViewControllerDelegate: loginFactory.getSignUpDelegate(),
                                                        coordinator: self
        )], animated: false)
    }
    
    func start() {
        let loginFactory = LoginFactory()
        let logInViewController = LogInViewController(
            loginViewControllerDelegate: loginFactory.getLognCredentialsValidator(),
            signUpViewControllerDelegate: loginFactory.getSignUpDelegate(),
            coordinator: self
        )
        navigationController.pushViewController(logInViewController, animated: false)
    }
    
    func openProfile(sender:UIButton?, loginInput: String) {
        let userService = CurrentUserService()
//        #if DEBUG
//        let userService = TestUserService()
//        #endif
        do {
            try navigationController.show(ProfileViewController(
                userService: userService, fullName: loginInput
            ), sender: sender)
        } catch ProfileViewController.ValidationError.notFound {
            showLoginError(title: String(localized: "Error"), message: String(localized: "Invalid login or password."))
        } catch {
            showLoginError(title: String(localized: "Something went wrong"), message: String(localized: "Try again later."))
        }
    }
    
    func showLoginError(title: String, message: String) {
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
        navigationController.present(alert, animated: true, completion: nil)
    }
}
