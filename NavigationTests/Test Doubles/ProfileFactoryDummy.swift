import UIKit

class ProfileFactoryDummy: ProfileFactoryProtocol {
    func createProfileViewController(userService: UserService, loginInput: String, coordinator: ProfileCoordinator) throws -> ProfileViewControllerProtocol {
        var vc = ProfileViewControllerDummy()
        return vc
    }
}

class ProfileViewControllerDummy: UIViewController, ProfileViewControllerProtocol {
    
}
