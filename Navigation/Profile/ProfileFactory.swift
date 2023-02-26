import UIKit

class ProfileFactory: ProfileFactoryProtocol {
    
    func createProfileViewController(userService: UserService, loginInput: String) -> ProfileViewControllerProtocol {
        return ProfileViewController(
            userService: userService, fullName: loginInput
        )
    }
}
