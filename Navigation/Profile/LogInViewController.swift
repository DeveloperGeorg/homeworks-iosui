import UIKit

class LogInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func loadView() {
        let loginView = LogInView()
        loginView.logInButton.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
        view = loginView
    }
    
    @objc private func openProfile(sender:UIButton) {
        self.show(ProfileViewController(), sender: sender)
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
