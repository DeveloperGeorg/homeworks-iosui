import Foundation

protocol SignUpViewControllerDelegateProtocol {
    func sugnUp(login: String, password: String) -> Bool
    func sugnUp(login: String, password: String, _ completionHandler: @escaping () -> Void, _ errorHandler: @escaping () -> Void) -> Void
}
