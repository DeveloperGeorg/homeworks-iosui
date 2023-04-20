import UIKit

class LogInView: UIView {
    let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            return scrollView
        }()

    let contentView:UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    let logoImageView: UIImageView = {
        let image = UIImage(named: "logo.png")
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = image
        return logoImageView
    }()
    
    let loginInput: CustomTextInput = {
        let loginInput = CustomTextInput()
        loginInput.placeholder = String(localized: "Email or phone")
        loginInput.layer.borderWidth = 0.5
        
        return loginInput
    }()
    
    let passwordInput: CustomTextInput = {
        let passwordInput = CustomTextInput()
        passwordInput.placeholder = String(localized: "Password")
        passwordInput.isSecureTextEntry = true
        passwordInput.layer.borderWidth = 0.5
        
        return passwordInput
    }()
    
    
    let logInButton: CustomButton = {
        let button = CustomButton(
            title: String(localized: "Log In"),
            titleColor: UiKitFacade.shared.getTextActionButtonColor(),
            titleFor: .normal,
            buttonTappedCallback: nil
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = UiKitFacade.shared.getConstraintContant(1.5)
        button.backgroundColor = UiKitFacade.shared.getBackgroundActionButtonDisabledColor()

        return button
    }()
    
    let signUpButton: CustomButton = {
        let button = CustomButton(
            title: String(localized: "Sign up"),
            titleColor: UiKitFacade.shared.getTextActionButtonColor(),
            titleFor: .normal,
            buttonTappedCallback: nil
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = UiKitFacade.shared.getConstraintContant(1.5)
        button.backgroundColor = UiKitFacade.shared.getBackgroundActionButtonDisabledColor()

        return button
    }()
    
    fileprivate enum CellReuseID: String {
        case login = "loginReuseID"
        case password = "passwordReuseID"
    }
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        addSubviews()
        activateConstraints()
        enabledButton(isEnabled: false, button: logInButton)
        enabledButton(isEnabled: false, button: signUpButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(loginInput)
        contentView.addSubview(passwordInput)
        contentView.addSubview(logInButton)
        contentView.addSubview(signUpButton)
    }
    
    private func activateConstraints() {
        let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightConstraint.priority = UILayoutPriority(rawValue: Float(UiKitFacade.shared.getConstraintContant(31)))
        let logoImageSize = UiKitFacade.shared.getConstraintContant(37)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            heightConstraint,
            
            logoImageView.widthAnchor.constraint(equalToConstant: CGFloat(logoImageSize)),
            logoImageView.heightAnchor.constraint(equalToConstant: CGFloat(logoImageSize)),
            logoImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UiKitFacade.shared.getConstraintContant(15)),
            
            loginInput.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: UiKitFacade.shared.getConstraintContant(5)),
            loginInput.heightAnchor.constraint(equalToConstant: UiKitFacade.shared.getConstraintContant(6)),
            loginInput.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: UiKitFacade.shared.getConstraintContant(2)),
            loginInput.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: UiKitFacade.shared.getConstraintContant(-2)),
            
            passwordInput.topAnchor.constraint(equalTo: loginInput.bottomAnchor, constant: 0),
            passwordInput.heightAnchor.constraint(equalToConstant: UiKitFacade.shared.getConstraintContant(6)),
            passwordInput.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: UiKitFacade.shared.getConstraintContant(2)),
            passwordInput.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: UiKitFacade.shared.getConstraintContant(-2)),
            
            logInButton.heightAnchor.constraint(equalToConstant: UiKitFacade.shared.getConstraintContant(6)),
            logInButton.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: UiKitFacade.shared.getConstraintContant(2)),
            logInButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: UiKitFacade.shared.getConstraintContant(2)),
            logInButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: UiKitFacade.shared.getConstraintContant(-2)),
            
            signUpButton.heightAnchor.constraint(equalToConstant: UiKitFacade.shared.getConstraintContant(6)),
            signUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: UiKitFacade.shared.getConstraintContant(2)),
            signUpButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: UiKitFacade.shared.getConstraintContant(2)),
            signUpButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: UiKitFacade.shared.getConstraintContant(-2)),
            
        ])
        
        loginInput.layer.cornerRadius = 20
        loginInput.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        passwordInput.layer.cornerRadius = 20
        passwordInput.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
    }
    
    func checkAndEnableLoginSignUpButtons() {
        if (loginInput.text ?? "").isEmpty || (passwordInput.text ?? "").isEmpty {
            enabledButton(isEnabled: false, button: logInButton)
            enabledButton(isEnabled: false, button: signUpButton)

        } else {
            enabledButton(isEnabled: true, button: logInButton)
            enabledButton(isEnabled: true, button: signUpButton)
        }
    }
    
    func enabledButton(isEnabled: Bool, button: UIButton) -> Void {
        button.isEnabled = isEnabled
        if isEnabled == true {
            button.backgroundColor = UiKitFacade.shared.getBackgroundActionButtonAnabledColor()
        } else {
            button.backgroundColor = UiKitFacade.shared.getBackgroundActionButtonDisabledColor()
        }
    }
}
