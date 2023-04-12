import UIKit

final class ApplicationCoordinator: Coordinatable {
    var navigationController: UINavigationController
    var window: UIWindow
    var rootController: UITabBarController = UITabBarController()
    
    var childCoordinators: [Coordinatable] = []
    
    var feedCoordinator: FeedCoordinator
    var profileCoordinator: ProfileCoordinator
    var favoritesCoordinator: FavoritesCoordinator
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.feedCoordinator = FeedCoordinator(navigationController: navigationController)
        self.navigationController.tabBarItem = UITabBarItem(title: String(localized: "Feed"), image: UIImage(systemName: "list.bullet"), selectedImage: nil)
        
        let loginFactory = LoginFactory()
        let userService = CurrentUserService()
        self.profileCoordinator = ProfileCoordinator(
            navigationController: UINavigationController(),
            loginFactory: loginFactory,
            profileFactory: ProfileFactory(),
            userService: userService
        )
        profileCoordinator.navigationController.tabBarItem = UITabBarItem(title: String(localized: "Profile"), image: UIImage(systemName: "person"), selectedImage: nil)
        profileCoordinator.navigationController.navigationBar.isHidden = true
        
        self.favoritesCoordinator = FavoritesCoordinator(
            navigationController: UINavigationController(),
            loginFactory: loginFactory,
            userService: userService
        )
        favoritesCoordinator.navigationController.tabBarItem = UITabBarItem(title: String(localized: "Favorites"), image: UIImage(named: "favorite")!, selectedImage: nil)
        
        self.rootController.setViewControllers([
            navigationController,
            profileCoordinator.navigationController,
            favoritesCoordinator.navigationController
        ], animated: false)
    }
    
    func start() {
        feedCoordinator.start()
        window.rootViewController = rootController
        window.makeKeyAndVisible()
    }
}
