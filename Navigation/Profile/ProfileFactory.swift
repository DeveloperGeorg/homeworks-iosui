import UIKit

class ProfileFactory: ProfileFactoryProtocol {
    
    func createProfileViewController(userService: UserService, coordinator: ProfileCoordinator) throws -> ProfileViewControllerProtocol {
        return try ProfileViewController(
            userService: userService, profileCoordinator: coordinator
        )
    }
}
