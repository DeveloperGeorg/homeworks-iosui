import UIKit

final class FeedCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    var postAggregateDetailViewCoordinator: PostAggregateDetailViewCoordinator
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.postAggregateDetailViewCoordinator = PostAggregateDetailViewCoordinator(navigationController: navigationController)
    }
    
    func start() {
        let feedViewController = FeedViewController(feedPresenter: FeedPresenter(coordinator: self))
        navigationController.pushViewController(feedViewController, animated: false)
    }
    
    func openPost(post: PostAggregate) {
        self.postAggregateDetailViewCoordinator.post = post
        self.postAggregateDetailViewCoordinator.start()
    }
}
