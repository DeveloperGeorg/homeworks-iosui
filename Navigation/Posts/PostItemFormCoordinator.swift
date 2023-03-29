import UIKit

class PostItemFormCoordinator: Coordinatable {
    var post: PostAggregate?
    var blogger: BloggerPreview?

    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if let blogger = self.blogger {
            navigationController.pushViewController(CreatePostViewController(postItemFormCoordinator: self, blogger: blogger), animated: true)
            navigationController.navigationBar.isHidden = false
        } else {
            print("No blogger was set")
        }
    }
 
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
