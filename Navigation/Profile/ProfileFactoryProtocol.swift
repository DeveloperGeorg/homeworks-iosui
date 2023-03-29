import UIKit

protocol ProfileFactoryProtocol {
    func createProfileViewController(userService: UserService, coordinator: ProfileCoordinator) throws -> ProfileViewControllerProtocol 
}
