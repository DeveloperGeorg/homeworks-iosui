import Foundation

class LoginFactory: LoginFactoryProtocol {
    func getLognCredentialsValidator() -> LoginViewControllerDelegateProtocol {
        return LoginInspector()
    }
    func getSignUpDelegate() -> SignUpViewControllerDelegateProtocol {
        return LoginInspector()
    }
}
