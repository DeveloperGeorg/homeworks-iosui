import UIKit

class MapsCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mapsViewController = MapsViewController()
        navigationController.pushViewController(mapsViewController, animated: false)
    }
}
