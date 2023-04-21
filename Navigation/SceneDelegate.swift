import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    fileprivate var coordinator: ApplicationCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        
        UITabBar.appearance().tintColor = UiKitFacade.shared.getAccentColor()
        UITabBar.appearance().unselectedItemTintColor = UiKitFacade.shared.getPrimaryTextColor()
        UINavigationBar.appearance().tintColor = UiKitFacade.shared.getAccentColor()
        coordinator = ApplicationCoordinator(window: window)
        coordinator?.start()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        let checkerService = CheckerService()
        checkerService.logout()
        print("logged out in sceneDidDisconnect")
    }
}


extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach{ addSubview($0) }
    }
}
