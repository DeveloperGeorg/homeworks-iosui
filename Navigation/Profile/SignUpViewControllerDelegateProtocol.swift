import Foundation

protocol SignUpViewControllerDelegateProtocol {
    func sugnUp(login: String, password: String, _ completionHandler: @escaping (User) -> Void, _ errorHandler: @escaping () -> Void) -> Void
}
