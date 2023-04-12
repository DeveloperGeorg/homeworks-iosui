import UIKit

class LoginFactoryDummy: LoginFactoryProtocol {
    
    func getLognCredentialsValidator() -> LoginViewControllerDelegateProtocol {
        return LoginViewControllerDelegateDummy()
    }
    func getSignUpDelegate() -> SignUpViewControllerDelegateProtocol {
        return SignUpViewControllerDelegateDummy()
    }
    func createLogInViewController(
        coordinator: Coordinatable,
        loginCompletionHandler: @escaping (User) -> Void
    ) -> LogInViewControllerProtocol {
        let vc = LogInViewControllerDummy()
        return vc
    }
}

class LogInViewControllerDummy: UIViewController, LogInViewControllerProtocol {
    
}

class LoginViewControllerDelegateDummy: LoginViewControllerDelegateProtocol {
    func checkCredentials(login: String, password: String, _ completion: @escaping (User) -> Void, _ errorHandler: @escaping () -> Void) {
        
    }
}

class SignUpViewControllerDelegateDummy: SignUpViewControllerDelegateProtocol {
    func sugnUp(login: String, password: String, _ completionHandler: @escaping (User) -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        
    }
}
