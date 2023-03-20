import UIKit

final class ApplicationCoordinator: Coordinatable {
    var navigationController: UINavigationController
    var window: UIWindow
    var rootController: UITabBarController = UITabBarController()
    
    var childCoordinators: [Coordinatable] = []
    
    var feedCoordinator: FeedCoordinator
    var profileCoordinator: ProfileCoordinator
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.feedCoordinator = FeedCoordinator(navigationController: navigationController)
        self.navigationController.tabBarItem = UITabBarItem(title: String(localized: "Feed"), image: UIImage(systemName: "list.bullet"), selectedImage: nil)
        self.profileCoordinator = ProfileCoordinator(
            navigationController: UINavigationController(),
            loginFactory: LoginFactory(),
            profileFactory: ProfileFactory(),
            userService: CurrentUserService()
        )
        profileCoordinator.navigationController.tabBarItem = UITabBarItem(title: String(localized: "Profile"), image: UIImage(systemName: "person"), selectedImage: nil)
        profileCoordinator.navigationController.navigationBar.isHidden = true
        self.rootController.setViewControllers([
            navigationController,
            profileCoordinator.navigationController
        ], animated: false)
    }
    
    func start() {
        feedCoordinator.start()
        window.rootViewController = rootController
        window.makeKeyAndVisible()
    }
}
