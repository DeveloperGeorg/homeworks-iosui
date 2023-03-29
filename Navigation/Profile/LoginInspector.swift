import Foundation

class LoginInspector: LoginViewControllerDelegateProtocol, SignUpViewControllerDelegateProtocol {
    private let checkerService: CheckerService = CheckerService()
    func checkCredentials(login: String, password: String, _ completion: @escaping (User) -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        return checkerService.checkCredentials(login: login, password: password, completion, errorHandler)
    }
    
    func sugnUp(login: String, password: String, _ completionHandler: @escaping (User) -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        checkerService.sugnUp(login: login, password: password, completionHandler, errorHandler)
    }
}
