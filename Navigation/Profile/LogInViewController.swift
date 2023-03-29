import UIKit
import FirebaseCore
import FirebaseAuth

class LogInViewController: UIViewController, LogInViewControllerProtocol, LoginViewControllerDelegateProtocol, SignUpViewControllerDelegateProtocol {
    
    enum ValidationError: Error {
            case invalidCredentials
        }

    private let loginView = LogInView()
    weak var coordinator: ProfileCoordinator?
    private let loginViewControllerDelegate: LoginViewControllerDelegateProtocol
    private let signUpViewControllerDelegate: SignUpViewControllerDelegateProtocol
    private let authUserStorage: AuthUserStorageProtocol
    private let localAuthorizationService = LocalAuthorizationService()
    private let userService: UserService

    public init(loginViewControllerDelegate: LoginViewControllerDelegateProtocol, signUpViewControllerDelegate: SignUpViewControllerDelegateProtocol, coordinator: ProfileCoordinator?) {
        self.loginViewControllerDelegate = loginViewControllerDelegate
        self.signUpViewControllerDelegate = signUpViewControllerDelegate
        self.coordinator = coordinator
        self.authUserStorage = RealmAuthUserStorage()
        self.userService = coordinator?.userService ?? CurrentUserService()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        let view = (self.view as! LogInView)
        view.loginInput.addTarget(self, action: #selector(enableLoginSignUpButtons), for: .editingChanged)
        view.passwordInput.addTarget(self, action: #selector(enableLoginSignUpButtons), for: .editingChanged)
    }
    
    override func loadView() {
        let lastAuthorized = self.authUserStorage.getLastAuthorized()
        if let lastAuthorizedUser = lastAuthorized {
            self.localAuthorizationService.authorizeIfPossible { (success, errorMessage) in
                guard success else {
                    self.coordinator?.showError(
                        title: String(localized: "Auto-login Error"),
                        message: errorMessage ?? String(localized: "Face ID/Touch ID may not be configured")
                    )
                    return
                }
                self.checkCredentials(login: lastAuthorizedUser.login, password: lastAuthorizedUser.password, ({ user in
                    self.authUserStorage.save(lastAuthorizedUser)
                    self.userService.storeCurrentUser(user)
                    self.coordinator?.openProfile(sender: nil)
                }), ({
                    self.coordinator?.showError(title: String(localized: "Auto-login Error"), message: String(localized: "Invalid auto-saved login or password."))
                }))
            }
            
        }
        loginView.logInButton.setButtonTappedCallback({ sender in
            let enteredPassword = self.loginView.passwordInput.text ?? "";
            let enteredLogin = self.loginView.loginInput.text ?? "";
            self.checkCredentials(login: enteredLogin, password: enteredPassword, ({ user in
                self.authUserStorage.save(RealmStoredAuthUser(login: enteredLogin, password: enteredPassword))
                self.userService.storeCurrentUser(user)
                self.coordinator?.openProfile(sender: sender)
            }), ({
                self.coordinator?.showError(title: String(localized: "Error"), message: String(localized: "Invalid login or password."))
            }))
        })
        loginView.signUpButton.setButtonTappedCallback({sender in
            let enteredPassword = self.loginView.passwordInput.text ?? "";
            let enteredLogin = self.loginView.loginInput.text ?? "";
            self.sugnUp(login: enteredLogin, password: enteredPassword, ({
                self.authUserStorage.save(RealmStoredAuthUser(login: enteredLogin, password: enteredPassword))
                self.coordinator?.openProfile(sender: sender)
            }), ({
                self.coordinator?.showError(title: String(localized: "Error"), message: String(localized: "Invalid login or password."))
            }))
        })
        view = loginView
    }
    
    func checkCredentials(login: String, password: String, _ completion: @escaping (User) -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        loginViewControllerDelegate.checkCredentials(login: login, password: password, completion, errorHandler)
    }
    
    func sugnUp(login: String, password: String, _ completionHandler: @escaping () -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        signUpViewControllerDelegate.sugnUp(login: login, password: password, completionHandler, errorHandler)
    }
                                                      
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let view = (self.view as! LogInView)
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = view.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        view.scrollView.contentInset = contentInset
        self.view = view
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        let view = (self.view as! LogInView)
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        view.scrollView.contentInset = contentInset
        self.view = view
    }
    
    @objc func enableLoginSignUpButtons() {
        let view = (self.view as! LogInView)
        view.checkAndEnableLoginSignUpButtons()
    }
}
