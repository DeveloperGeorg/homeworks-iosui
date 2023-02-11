import UIKit

final class ApplicationCoordinator: Coordinatable {
    var navigationController: UINavigationController
    var window: UIWindow
    var rootController: UITabBarController = UITabBarController()
    
    var childCoordinators: [Coordinatable] = []
    
    var feedCoordinator: FeedCoordinator
    var profileCoordinator: ProfileCoordinator
    var mapsCoordinator: MapsCoordinator
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.feedCoordinator = FeedCoordinator(navigationController: navigationController)
        self.navigationController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "list.bullet"), selectedImage: nil)
        self.profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
        profileCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: nil)
        profileCoordinator.navigationController.navigationBar.isHidden = true
        self.mapsCoordinator = MapsCoordinator(navigationController: UINavigationController())
        mapsCoordinator.navigationController.tabBarItem = UITabBarItem(title: "Maps", image: UIImage(systemName: "map"), selectedImage: nil)
        self.rootController.setViewControllers([
            navigationController,
            profileCoordinator.navigationController,
            mapsCoordinator.navigationController
        ], animated: false)
    }
    
    func start() {
        feedCoordinator.start()
        window.rootViewController = rootController
        window.makeKeyAndVisible()
    }
    
    func showOverworkAlertTimer(okClosure: (() -> Void)?, cancelClosure: (() -> Void)?) -> Void {
        let alert = UIAlertController(title: "Отдохни", message: "Ты работал очень много. Нужно отдохнуть", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            okClosure?()
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
            UIAlertAction in
            cancelClosure?()
        }
        alert.addAction(cancelAction)
        self.navigationController.present(alert, animated: true, completion: nil)
    }
}
