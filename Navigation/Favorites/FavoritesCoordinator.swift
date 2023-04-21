import UIKit

final class FavoritesCoordinator: Coordinatable{
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    let userService: UserService
    var postAggregateDetailViewCoordinator: PostAggregateDetailViewCoordinator
    
    init(
        navigationController: UINavigationController,
        userService: UserService
    ) {
        self.navigationController = navigationController
        self.userService = userService
        self.postAggregateDetailViewCoordinator = PostAggregateDetailViewCoordinator(navigationController: navigationController, userService: self.userService)
        openFavorites()
    }
    
    func start() {
        openFavorites()
    }
    
    func openFavorites() {
        do {
            let favoritesViewController = try FavoritesViewController(favoritesCoordinator: self, userService: self.userService)
            navigationController.pushViewController(favoritesViewController, animated: false)
        } catch {
            self.showError(title: String(localized: "Error occurred"), message: String(localized: "Something went wrong. Try again later"))
        }
    }
    
    func openPost(post: PostAggregate) {
        self.postAggregateDetailViewCoordinator.post = post
        self.postAggregateDetailViewCoordinator.start()
    }
}
