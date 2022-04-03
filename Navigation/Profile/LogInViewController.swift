import UIKit

class LogInViewController: UIViewController, LoginViewControllerDelegateProtocol {
    enum ValidationError: Error {
            case invalidCredentials
        }

    private let loginView = LogInView()
    weak var coordinator: ProfileCoordinator?
    private let loginViewControllerDelegate: LoginViewControllerDelegateProtocol

    public init(coordinator: ProfileCoordinator?) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
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
            coordinator?.openProfile(sender: sender, loginInput: loginView.loginInput.text ?? "")
            /*
                let userService = CurrentUserService()
                #if DEBUG
                let userService = TestUserService()
                #endif
                do {
                    if !self.checkCredentials(login: self.loginView.loginInput.text ?? "", password: self.loginView.passwordInput.text ?? "") {
                        throw ValidationError.invalidCredentials
                    }
                    try self.show(ProfileViewController(
                        userService: userService, fullName: self.loginView.loginInput.text ?? ""
                    ), sender: sender)
                } catch ProfileViewController.ValidationError.notFound, ValidationError.invalidCredentials {
                    let alert = UIAlertController(title: "Error", message: "Invalid login or password.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) {
                        UIAlertAction in
                        print("Pressed OK action")
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                catch {
                       print("JSONSerialization error:", error)
                   }
            */
        })
        view = loginView
    }
    
    
    init(loginViewControllerDelegate: LoginViewControllerDelegateProtocol) {
        self.loginViewControllerDelegate = loginViewControllerDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
