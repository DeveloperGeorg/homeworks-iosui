import UIKit

class PostItemFormCoordinator: Coordinatable {
    var post: PostAggregate?

    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.pushViewController(CreatePostViewController(postItemFormCoordinator: self), animated: true)
        navigationController.navigationBar.isHidden = false
    }
 
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
