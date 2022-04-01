import UIKit

final class ProfileCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setViewControllers([LogInViewController(coordinator: self)], animated: false)
    }
    
    func start() {
        let logInViewController = LogInViewController(coordinator: self)
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
            let alert = UIAlertController(title: "Error", message: "Invalid login or password.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                print("Pressed OK action")
            }
            alert.addAction(okAction)
            navigationController.present(alert, animated: true, completion: nil)
        } catch {
            print("Something went wrong")
        }
    }
    
}
