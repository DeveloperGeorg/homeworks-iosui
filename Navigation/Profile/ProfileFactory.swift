import UIKit

class ProfileFactory: ProfileFactoryProtocol {
    
    func createProfileViewController(userService: UserService, loginInput: String) -> UIViewController {
        return ProfileViewController(
            userService: userService, fullName: loginInput
        )
    }
}
