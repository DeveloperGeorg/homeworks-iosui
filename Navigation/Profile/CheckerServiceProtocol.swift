import Foundation

protocol CheckerServiceProtocol {
    func checkCredentials(login: String, password: String, _ completion: @escaping (User) -> Void, _ errorHandler: @escaping () -> Void) -> Void
    func sugnUp(login: String, password: String, _ completionHandler: @escaping () -> Void, _ errorHandler: @escaping () -> Void) -> Void
}
