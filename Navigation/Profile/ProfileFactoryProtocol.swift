import UIKit

protocol ProfileFactoryProtocol {
    func createProfileViewController(userService: UserService, loginInput: String, coordinator: ProfileCoordinator) -> ProfileViewControllerProtocol
}
