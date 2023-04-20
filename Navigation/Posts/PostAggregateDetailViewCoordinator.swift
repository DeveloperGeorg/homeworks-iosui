import UIKit

class PostAggregateDetailViewCoordinator: Coordinatable {
    var post: PostAggregate?

    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    let userService: UserService
    
    init(navigationController: UINavigationController, userService: UserService) {
        self.navigationController = navigationController
        self.userService = userService
    }
    
    func start() {
        if let post = self.post {
            navigationController.pushViewController(PostAggregateViewController(post: post, userService: self.userService), animated: true)
            navigationController.navigationBar.isHidden = false
        } else {
            /** @todo print error */
            print("error:no post aggregate was found")
        }
    }
}
