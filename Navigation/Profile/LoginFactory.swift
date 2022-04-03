import Foundation

class LoginFactory: LoginFactoryProtocol {
    func getLognCredentialsValidator() -> LoginViewControllerDelegateProtocol {
        return LoginInspector()
    }
}
