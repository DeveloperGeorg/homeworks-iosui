import UIKit

class ProfileFactory: ProfileFactoryProtocol {
    
    func createProfileViewController(userService: UserService, loginInput: String, coordinator: ProfileCoordinator) throws -> ProfileViewControllerProtocol {
        return try ProfileViewController(
            userService: userService, fullName: loginInput, profileCoordinator: coordinator
        )
    }
}
