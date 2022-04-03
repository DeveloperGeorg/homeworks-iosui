import UIKit

final class ProfileCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let loginFactory = LoginFactory()
        self.navigationController.setViewControllers([LogInViewController(
                                                        loginViewControllerDelegate: loginFactory.getLognCredentialsValidator(),
                                                        coordinator: self
        )], animated: false)
    }
    
    func start() {
        let loginFactory = LoginFactory()
        let logInViewController = LogInViewController(
            loginViewControllerDelegate: loginFactory.getLognCredentialsValidator(),
            coordinator: self
        )
        navigationController.pushViewController(logInViewController, animated: false)
    }
    
    func openProfile(sender:UIButton, loginInput: String) {
        let userService = CurrentUserService()
        #if DEBUG
        let userService = TestUserService()
        #endif
        do {
            try navigationController.show(ProfileViewController(
                userService: userService, fullName: loginInput
            ), sender: sender)
        } catch ProfileViewController.ValidationError.notFound {
            showLoginError(title: "Error", message: "Invalid login or password.")
        } catch {
            showLoginError(title: "Something went wrong", message: "Try again later.")
        }
    }
    
    func showLoginError(title: String, message: String) {
        let alert = UIAlertController(title: "Error", message: "Invalid login or password.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            print("Pressed OK action")
        }
        alert.addAction(okAction)
        navigationController.present(alert, animated: true, completion: nil)
    }
}
