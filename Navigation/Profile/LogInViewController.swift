import UIKit

class LogInViewController: UIViewController, LoginViewControllerDelegateProtocol {
    enum ValidationError: Error {
            case invalidCredentials
        }

    private let loginView = LogInView()
    weak var coordinator: ProfileCoordinator?
    private let loginViewControllerDelegate: LoginViewControllerDelegateProtocol
    private var bruteForcer = BruteForcer()

    public init(loginViewControllerDelegate: LoginViewControllerDelegateProtocol, coordinator: ProfileCoordinator?) {
        self.loginViewControllerDelegate = loginViewControllerDelegate
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
    }
    
    override func loadView() {
        loginView.logInButton.setButtonTappedCallback({ sender in
            
            do {
                if !self.checkCredentials(login: self.loginView.loginInput.text ?? "", password: self.loginView.passwordInput.text ?? "") {
                    throw ValidationError.invalidCredentials
                }
            } catch ValidationError.invalidCredentials {
                self.coordinator?.showLoginError(title: "Error", message: "Invalid login or password.")
            } catch {
                self.coordinator?.showLoginError(title: "Something went wrong", message: "Try again later.")
            }
            
            self.coordinator?.openProfile(sender: sender, loginInput: self.loginView.loginInput.text ?? "")
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
        view = loginView
    }
    
    
    init(loginViewControllerDelegate: LoginViewControllerDelegateProtocol) {
        self.loginViewControllerDelegate = loginViewControllerDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    func checkCredentials(login: String, password: String) -> Bool {
        return loginViewControllerDelegate.checkCredentials(login: login, password: password)
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
}
