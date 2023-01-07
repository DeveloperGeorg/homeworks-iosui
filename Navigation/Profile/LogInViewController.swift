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
    private var bruteForcer = BruteForcer()

    public init(loginViewControllerDelegate: LoginViewControllerDelegateProtocol, signUpViewControllerDelegate: SignUpViewControllerDelegateProtocol, coordinator: ProfileCoordinator?) {
        self.loginViewControllerDelegate = loginViewControllerDelegate
        self.signUpViewControllerDelegate = signUpViewControllerDelegate
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        bruteForcer.setLoginViewControllerDelegate(self)
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
        loginView.logInButton.setButtonTappedCallback({ sender in
            do {
                self.checkCredentials(login: self.loginView.loginInput.text ?? "", password: self.loginView.passwordInput.text ?? "", ({
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
        loginView.bruteForceForgottenPasswordButton.setButtonTappedCallback({sender in
            self.loginView.startBruteForcing()
            let login: String = self.loginView.loginInput.text ?? ""
            guard login != "" else {
                self.loginView.stopBruteForcing()
                return
            }
            self.bruteForcer.bruteForce(login: self.loginView.loginInput.text!, completion: { password in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.loginView.passwordInput.text = password
                    self.loginView.passwordInput.isSecureTextEntry = false
                    self.loginView.stopBruteForcing()
                }
            })
        })
        loginView.signUpButton.setButtonTappedCallback({sender in
            print("SignUp button was tapped")
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
    
    func checkCredentials(login: String, password: String) -> Bool {
        return loginViewControllerDelegate.checkCredentials(login: login, password: password)
    }
    
    func checkCredentials(login: String, password: String, _ completion: @escaping () -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        loginViewControllerDelegate.checkCredentials(login: login, password: password, completion, errorHandler)
    }
    
    func sugnUp(login: String, password: String) -> Bool {
        return signUpViewControllerDelegate.sugnUp(login: login, password: password)
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
