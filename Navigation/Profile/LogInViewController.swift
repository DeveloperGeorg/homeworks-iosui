import UIKit

class LogInViewController: UIViewController {
    private let loginView = LogInView()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func loadView() {
        loginView.logInButton.setButtonTappedCallback({ sender in
            let userService = CurrentUserService()
            #if DEBUG
            let userService = TestUserService()
            #endif
            do {
                try self.show(ProfileViewController(
                    userService: userService, fullName: self.loginView.loginInput.text ?? ""
                ), sender: sender)
            } catch ProfileViewController.ValidationError.notFound {
                let alert = UIAlertController(title: "Error", message: "Invalid login or password.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) {
                    UIAlertAction in
                    print("Pressed OK action")
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } catch {
                print("Something went wrong")
            }
        })
        view = loginView
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
