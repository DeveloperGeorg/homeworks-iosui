import UIKit

final class ApplicationCoordinator: Coordinatable {
    var navigationController: UINavigationController
    var window: UIWindow
    var rootController: UITabBarController = UITabBarController()
    let loginFactory = LoginFactory()
    let userService = CurrentUserService()
    
    var childCoordinators: [Coordinatable] = []
    
    var feedCoordinator: FeedCoordinator?
    var profileCoordinator: ProfileCoordinator?
    var favoritesCoordinator: FavoritesCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        
        self.feedCoordinator = FeedCoordinator(
            navigationController: self.navigationController,
            userService: self.userService
        )
        self.feedCoordinator?.navigationController.tabBarItem = UITabBarItem(title: String(localized: "Feed"), image: UIImage(systemName: "list.bullet"), selectedImage: nil)
        self.feedCoordinator?.navigationController.navigationBar.isHidden = true
        
        self.rootController.setViewControllers([navigationController], animated: false)
    }
    
    func start() {
        let logInViewController = loginFactory.createLogInViewController(coordinator: self, loginCompletionHandler: { user in
            self.userService.storeCurrentUser(user)
            
            self.profileCoordinator = ProfileCoordinator(
                navigationController: UINavigationController(),
                profileFactory: ProfileFactory(),
                userService: self.userService
            )
            self.profileCoordinator?.navigationController.tabBarItem = UITabBarItem(title: String(localized: "Profile"), image: UIImage(systemName: "person"), selectedImage: nil)
            self.profileCoordinator?.navigationController.navigationBar.isHidden = true
            
            self.favoritesCoordinator = FavoritesCoordinator(
                navigationController: UINavigationController(),
                userService: self.userService
            )
            self.favoritesCoordinator?.navigationController.tabBarItem = UITabBarItem(title: String(localized: "Favorites"), image: UIImage(named: "favorite")!, selectedImage: nil)
            self.favoritesCoordinator?.navigationController.navigationBar.isHidden = true
            
            var viewControllers: [UIViewController] = []
            viewControllers.append(self.navigationController)
            if let navController = self.profileCoordinator?.navigationController {
                viewControllers.append(navController)
            }
            if let navController = self.favoritesCoordinator?.navigationController {
                viewControllers.append(navController)
            }
            self.rootController.setViewControllers(viewControllers, animated: false)
            
            self.rootController.tabBar.isHidden = false
            self.feedCoordinator?.start()
        })
        self.navigationController.setViewControllers([logInViewController], animated: false)
        rootController.tabBar.isHidden = true
        window.rootViewController = rootController
        window.makeKeyAndVisible()
    }
}
