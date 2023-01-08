import UIKit
import FirebaseCore
import FirebaseAuth

class LogInViewController: UIViewController, LoginViewControllerDelegateProtocol, SignUpViewControllerDelegateProtocol {
    
    enum ValidationError: Error {
            case invalidCredentials
        }

    private let loginView = LogInView()
    weak var coordinator: ProfileCoordinator?
    private let loginViewControllerDelegate: LoginViewControllerDelegateProtocol
    private let signUpViewControllerDelegate: SignUpViewControllerDelegateProtocol
    private let authUserStorage: AuthUserStorageProtocol

    public init(loginViewControllerDelegate: LoginViewControllerDelegateProtocol, signUpViewControllerDelegate: SignUpViewControllerDelegateProtocol, coordinator: ProfileCoordinator?) {
        self.loginViewControllerDelegate = loginViewControllerDelegate
        self.signUpViewControllerDelegate = signUpViewControllerDelegate
        self.coordinator = coordinator
        self.authUserStorage = RealmAuthUserStorage()
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
            self.checkCredentials(login: lastAuthorizedUser.login, password: lastAuthorizedUser.password, ({
                self.authUserStorage.save(lastAuthorizedUser)
                self.coordinator?.openProfile(sender: nil, loginInput: lastAuthorizedUser.login)
            }), ({
                self.coordinator?.showLoginError(title: "Error", message: "Invalid login or password.")
            }))
            
        }
        loginView.logInButton.setButtonTappedCallback({ sender in
            do {
                let enteredPassword = self.loginView.passwordInput.text ?? "";
                let enteredLogin = self.loginView.loginInput.text ?? "";
                self.checkCredentials(login: enteredLogin, password: enteredPassword, ({
                    self.authUserStorage.save(RealmStoredAuthUser(login: enteredLogin, password: enteredPassword))
                    self.coordinator?.openProfile(sender: sender, loginInput: enteredLogin)
                }), ({
                    self.coordinator?.showLoginError(title: "Error", message: "Invalid login or password.")
                }))
            } catch ValidationError.invalidCredentials {
                self.coordinator?.showLoginError(title: "Error", message: "Invalid login or password.")
            } catch {
                self.coordinator?.showLoginError(title: "Something went wrong", message: "Try again later.")
            }
        })
        loginView.signUpButton.setButtonTappedCallback({sender in
            do {
                self.sugnUp(login: self.loginView.loginInput.text ?? "", password: self.loginView.passwordInput.text ?? "", ({
                    self.coordinator?.openProfile(sender: sender, loginInput: self.loginView.loginInput.text ?? "")
                }), ({
                    self.coordinator?.showLoginError(title: "Error", message: "Invalid login or password.")
                }))
            } catch ValidationError.invalidCredentials {
                self.coordinator?.showLoginError(title: "Error", message: "Invalid login or password.")
            } catch {
                self.coordinator?.showLoginError(title: "Something went wrong", message: "Try again later.")
            }
        })
        view = loginView
    }
    
    func checkCredentials(login: String, password: String, _ completion: @escaping () -> Void, _ errorHandler: @escaping () -> Void) -> Void {
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
