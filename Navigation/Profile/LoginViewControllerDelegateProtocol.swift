import Foundation


protocol LoginViewControllerDelegateProtocol {
    func checkCredentials(login: String, password: String, _ completion: @escaping () -> Void, _ errorHandler: @escaping () -> Void) -> Void
}
