import UIKit

class LoginFactoryDummy: LoginFactoryProtocol {
    
    func getLognCredentialsValidator() -> LoginViewControllerDelegateProtocol {
        return LoginViewControllerDelegateDummy()
    }
    func getSignUpDelegate() -> SignUpViewControllerDelegateProtocol {
        return SignUpViewControllerDelegateDummy()
    }
    func createLogInViewController(coordinator: ProfileCoordinator) -> LogInViewControllerProtocol {
        let vc = LogInViewControllerDummy()
        return vc
    }
    func createLoginError(title: String, message: String) -> UIAlertController {
        return UIAlertController()
    }
}

class LogInViewControllerDummy: UIViewController, LogInViewControllerProtocol {
    
}

class LoginViewControllerDelegateDummy: LoginViewControllerDelegateProtocol {
    func checkCredentials(login: String, password: String, _ completion: @escaping () -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        
    }
}

class SignUpViewControllerDelegateDummy: SignUpViewControllerDelegateProtocol {
    func sugnUp(login: String, password: String, _ completionHandler: @escaping () -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        
    }
}
