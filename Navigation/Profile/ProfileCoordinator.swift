import UIKit

final class ProfileCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    let profileFactory: ProfileFactoryProtocol
    let userService: UserService
    let postAggregateDetailViewCoordinator: PostAggregateDetailViewCoordinator
    let postItemFormCoordinator: PostItemFormCoordinator
    
    init(
        navigationController: UINavigationController,
        profileFactory: ProfileFactoryProtocol,
        userService: UserService
    ) {
        self.navigationController = navigationController
        self.profileFactory = profileFactory
        self.userService = userService
        self.postAggregateDetailViewCoordinator = PostAggregateDetailViewCoordinator(navigationController: navigationController, userService: self.userService)
        self.postItemFormCoordinator = PostItemFormCoordinator(navigationController: navigationController)
        self.openProfile(nil)
    }
    
    func start() {
        self.openProfile(nil)
    }
    
    func openProfile(_ user: User?) {
        do {
            let profileController = try self.profileFactory.createProfileViewController(
                userService: self.userService, coordinator: self
            )
            self.navigationController.setViewControllers([profileController], animated: true)
        } catch {
            self.showError(title: String(localized: "Error occurred"), message: String(localized: "Something went wrong. Try again later"))
        }
    }
    
    func openProfileEdit(_ user: User) {
        self.navigationController.pushViewController(ProfileEditViewController(user: user, coordinator: self), animated: true)
    }
    
    func openPost(post: PostAggregate) {
        self.postAggregateDetailViewCoordinator.post = post
        self.postAggregateDetailViewCoordinator.start()
    }

    func createPost() {
        self.postItemFormCoordinator.start()
    }
    
    func setBlogger(_ blogger: BloggerPreview) {
        self.postItemFormCoordinator.blogger = blogger
    }
}
