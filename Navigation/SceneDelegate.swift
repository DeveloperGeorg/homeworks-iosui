import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let tabBarController = UITabBarController()
        let feedNavigationController = UINavigationController()
        feedNavigationController.pushViewController(FeedViewController(parentNavigationController: feedNavigationController), animated: false)
        feedNavigationController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "list.bullet"), selectedImage: nil)
        let loginInspector = LoginInspector()
        let loginNavigationController = UINavigationController(rootViewController: LogInViewController(loginViewControllerDelegate: loginInspector))
        loginNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: nil)
        loginNavigationController.navigationBar.isHidden = true
        tabBarController.setViewControllers([
            feedNavigationController,
            loginNavigationController
        ], animated: false)
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
}

