import UIKit

final class ProfileCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    let loginFactory: LoginFactoryProtocol
    let profileFactory: ProfileFactoryProtocol
    let userService: UserService
    var postAggregateDetailViewCoordinator: PostAggregateDetailViewCoordinator
    
    init(
        navigationController: UINavigationController,
        loginFactory: LoginFactoryProtocol,
        profileFactory: ProfileFactoryProtocol,
        userService: UserService
    ) {
        self.navigationController = navigationController
        self.loginFactory = loginFactory
        self.profileFactory = profileFactory
        self.userService = userService
        self.postAggregateDetailViewCoordinator = PostAggregateDetailViewCoordinator(navigationController: navigationController)
        let logInViewController = loginFactory.createLogInViewController(coordinator: self)
        self.navigationController.setViewControllers([logInViewController], animated: false)
    }
    
    func start() {
        let logInViewController = self.loginFactory.createLogInViewController(coordinator: self)
        navigationController.pushViewController(logInViewController, animated: false)
    }
    
    func openProfile(sender:UIButton?, loginInput: String) {
        navigationController.show(self.profileFactory.createProfileViewController(
            userService: self.userService, loginInput: loginInput, coordinator: self
        ), sender: sender)
    }
    
    func showLoginError(title: String, message: String) {
        let alert = self.loginFactory.createLoginError(title: title, message: message)
        navigationController.present(alert, animated: true, completion: nil)
    }
    
    func openPost(post: PostAggregate) {
        self.postAggregateDetailViewCoordinator.post = post
        self.postAggregateDetailViewCoordinator.start()
    }
}
