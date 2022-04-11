import UIKit

protocol Presentable {
    var toPresent: UIViewController? { get }
}

protocol Routable: Presentable {
    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)
}

extension UIViewController: Presentable {
    var toPresent: UIViewController? {
        self
    }
}
