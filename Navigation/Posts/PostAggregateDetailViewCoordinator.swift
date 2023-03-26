import UIKit

class PostAggregateDetailViewCoordinator: Coordinatable {
    var post: PostAggregate?

    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        if let post = self.post {
            navigationController.pushViewController(PostAggregateViewController(post: post), animated: true)
            navigationController.navigationBar.isHidden = false
        } else {
            /** @todo print error */
            print("error:no post aggregate was found")
        }
    }
}
