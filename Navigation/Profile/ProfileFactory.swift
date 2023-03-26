import UIKit

class ProfileFactory: ProfileFactoryProtocol {
    
    func createProfileViewController(userService: UserService, loginInput: String, coordinator: ProfileCoordinator) -> ProfileViewControllerProtocol {
        return ProfileViewController(
            userService: userService, fullName: loginInput, profileCoordinator: coordinator
        )
    }
}
