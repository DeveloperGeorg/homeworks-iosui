import UIKit

protocol Coordinatable: AnyObject {
    var childCoordinators: [Coordinatable] { get set}
    var navigationController: UINavigationController { get set }
    
    func start()
}
