import UIKit

final class FeedCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    var postAggregateDetailViewCoordinator: PostAggregateDetailViewCoordinator
    let userService: UserService
    
    init(navigationController: UINavigationController, userService: UserService) {
        self.navigationController = navigationController
        self.userService = userService
        self.postAggregateDetailViewCoordinator = PostAggregateDetailViewCoordinator(navigationController: navigationController, userService: self.userService)
    }
    
    func start() {
        let feedViewController = try! FeedViewController(feedCoordinator: self, userService: userService)
        navigationController.setViewControllers([feedViewController], animated: false)
    }
    
    func openPost(post: PostAggregate) {
        self.postAggregateDetailViewCoordinator.post = post
        self.postAggregateDetailViewCoordinator.start()
    }
}
