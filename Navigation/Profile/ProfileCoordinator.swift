import UIKit

final class ProfileCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    let loginFactory: LoginFactory
    let profileFactory: ProfileFactoryProtocol
    let userService: CurrentUserService
    
    init(
        navigationController: UINavigationController,
        loginFactory: LoginFactory,
        profileFactory: ProfileFactoryProtocol,
        userService: CurrentUserService
    ) {
        self.navigationController = navigationController
        self.loginFactory = loginFactory
        self.profileFactory = profileFactory
        self.userService = userService
        let logInViewController = loginFactory.createLogInViewController(coordinator: self)
        self.navigationController.setViewControllers([logInViewController], animated: false)
    }
    
    func start() {
        let logInViewController = self.loginFactory.createLogInViewController(coordinator: self)
        navigationController.pushViewController(logInViewController, animated: false)
    }
    
    func openProfile(sender:UIButton?, loginInput: String) {
        navigationController.show(self.profileFactory.createProfileViewController(
            userService: self.userService, loginInput: loginInput
        ), sender: sender)
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
