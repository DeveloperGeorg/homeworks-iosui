import UIKit

final class ProfileCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    let loginFactory: LoginFactoryProtocol
    let profileFactory: ProfileFactoryProtocol
    let userService: UserService
    let postAggregateDetailViewCoordinator: PostAggregateDetailViewCoordinator
    let postItemFormCoordinator: PostItemFormCoordinator
    var isLoggedIn = false
    
    init(
        navigationController: UINavigationController,
        loginFactory: LoginFactoryProtocol,
        profileFactory: ProfileFactoryProtocol,
        userService: UserService
    ) {
        self.navigationController = navigationController
        self.loginFactory = loginFactory
        self.profileFactory = profileFactory
        self.userService = userService
        self.postAggregateDetailViewCoordinator = PostAggregateDetailViewCoordinator(navigationController: navigationController)
        self.postItemFormCoordinator = PostItemFormCoordinator(navigationController: navigationController)
        let logInViewController = loginFactory.createLogInViewController(coordinator: self, loginCompletionHandler: { user in
            self.userService.storeCurrentUser(user)
            self.openProfile(user)
        })
        self.navigationController.setViewControllers([logInViewController], animated: false)
    }
    
    func start() {
        if isLoggedIn {
            let logInViewController = self.loginFactory.createLogInViewController(coordinator: self, loginCompletionHandler: { user in
                self.openProfile(user)
            })
            navigationController.pushViewController(logInViewController, animated: false)
        } else {
            self.openProfile(nil)
        }
    }
    
    func openProfile(_ user: User?) {
        do {
            let profileController = try self.profileFactory.createProfileViewController(
                userService: self.userService, coordinator: self
            )
            if !isLoggedIn {
                self.navigationController.setViewControllers([profileController], animated: true)
            }
            isLoggedIn = true
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
