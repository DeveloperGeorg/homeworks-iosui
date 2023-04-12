import UIKit

final class FavoritesCoordinator: Coordinatable{
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    let loginFactory: LoginFactoryProtocol
    let userService: UserService
    var postAggregateDetailViewCoordinator: PostAggregateDetailViewCoordinator
    var isLoggedIn = false
    
    init(
        navigationController: UINavigationController,
        loginFactory: LoginFactoryProtocol,
        userService: UserService
    ) {
        self.navigationController = navigationController
        self.loginFactory = loginFactory
        self.userService = userService
        self.postAggregateDetailViewCoordinator = PostAggregateDetailViewCoordinator(navigationController: navigationController)
        let logInViewController = loginFactory.createLogInViewController(coordinator: self, loginCompletionHandler: { user in
            self.isLoggedIn = true
            self.openFavorites()
        })
        self.navigationController.setViewControllers([logInViewController], animated: false)
    }
    
    func start() {
        if isLoggedIn {
            let logInViewController = loginFactory.createLogInViewController(coordinator: self, loginCompletionHandler: { user in
                self.start()
            })
            navigationController.pushViewController(logInViewController, animated: false)
        } else {
            openFavorites()
        }
    }
    
    func openFavorites() {
        let favoritesViewController = FavoritesViewController(favoritesCoordinator: self)
        navigationController.pushViewController(favoritesViewController, animated: false)
    }
    
    func openPost(post: PostAggregate) {
        self.postAggregateDetailViewCoordinator.post = post
        self.postAggregateDetailViewCoordinator.start()
    }
}
