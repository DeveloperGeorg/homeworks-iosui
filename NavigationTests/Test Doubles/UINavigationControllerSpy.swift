import UIKit

class UINavigationControllerSpy: UINavigationController
{
    var lastShowedUiViewController: UIViewController? = nil

    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.lastShowedUiViewController = viewController
    }
    
    override func show(_ vc: UIViewController, sender: Any?) {
        self.lastShowedUiViewController = vc
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.lastShowedUiViewController = viewControllerToPresent
    }
}
