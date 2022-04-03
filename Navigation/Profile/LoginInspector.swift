import Foundation

class LoginInspector: LoginViewControllerDelegateProtocol {
    func checkCredentials(login: String, password: String) -> Bool {
        return CredentialsCheckerService.shared.check(login: login, password: password)
    }
}
