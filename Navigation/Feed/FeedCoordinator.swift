import UIKit

final class FeedCoordinator: Coordinatable {
    var childCoordinators: [Coordinatable] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let feedViewController = FeedViewController(feedPresenter: FeedPresenter(coordinator: self))
        navigationController.pushViewController(feedViewController, animated: false)
    }
    
    func openPost(postTitle: String) {
        navigationController.pushViewController(PostViewController(postTitle: postTitle, coordinator: self), animated: true)
    }
    
    func showInfo() {
        let infoModal = InfoViewController(coordinator: self)
        navigationController.present(infoModal, animated: true, completion: nil)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: String(localized: "My Alert"), message: String(localized: "This is an alert."), preferredStyle: .alert)
        let okAction = UIAlertAction(title: String(localized: "OK"), style: .default) {
            UIAlertAction in
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: String(localized: "Cancel"), style: .default) {
            UIAlertAction in
        }
        alert.addAction(cancelAction)
        navigationController.present(alert, animated: true, completion: nil)
    }
}
