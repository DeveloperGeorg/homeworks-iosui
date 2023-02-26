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
    
    let loginInput: UITextField = {
        let loginInput = UITextField()
        loginInput.translatesAutoresizingMaskIntoConstraints = false
        loginInput.backgroundColor = UIColor.createColor(
            lightMode: UIColor(red: CGFloat(242.0/255.0), green: CGFloat(242.0/255.0), blue: CGFloat(247.0/255.0), alpha: CGFloat(1.0)),
            darkMode: UIColor(red: CGFloat(42.0/255.0), green: CGFloat(42.0/255.0), blue: CGFloat(47.0/255.0), alpha: CGFloat(1.0))
        )
        loginInput.textColor = UIColor.createColor(lightMode: .gray, darkMode: .white)
        loginInput.layer.borderColor = UIColor.createColor(lightMode: UIColor.lightGray, darkMode: UIColor.white).cgColor
        loginInput.layer.borderWidth = 0.5
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        loginInput.leftView = paddingView
        loginInput.leftViewMode = .always
        
        loginInput.placeholder = String(localized: "Email or phone")
        
        return loginInput
    }()
    
    let passwordInput: UITextField = {
        let passwordInput = UITextField()
        passwordInput.translatesAutoresizingMaskIntoConstraints = false
        passwordInput.backgroundColor = UIColor.createColor(
            lightMode: UIColor(red: CGFloat(242.0/255.0), green: CGFloat(242.0/255.0), blue: CGFloat(247.0/255.0), alpha: CGFloat(1.0)),
            darkMode: UIColor(red: CGFloat(42.0/255.0), green: CGFloat(42.0/255.0), blue: CGFloat(47.0/255.0), alpha: CGFloat(1.0))
        )
        passwordInput.textColor = UIColor.createColor(lightMode: .gray, darkMode: .white)
        passwordInput.layer.borderColor = UIColor.createColor(lightMode: UIColor.lightGray, darkMode: UIColor.white).cgColor
        passwordInput.layer.borderWidth = 0.5
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        passwordInput.leftView = paddingView
        passwordInput.leftViewMode = .always
        
        passwordInput.placeholder = String(localized: "Password")
        passwordInput.isSecureTextEntry = true
        
        return passwordInput
    }()
    
    
    let logInButton: CustomButton = {
        let button = CustomButton(title: String(localized: "Log In"), titleColor: .white, titleFor: .normal, buttonTappedCallback: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.createColor(lightMode: UIColor(ciColor: .gray), darkMode: UIColor.lightGray)

        return button
    }()
    
    let signUpButton: CustomButton = {
        let button = CustomButton(title: String(localized: "Sign up"), titleColor: .white, titleFor: .normal, buttonTappedCallback: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.createColor(lightMode: UIColor(ciColor: .gray), darkMode: UIColor.lightGray)

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
        heightConstraint.priority = UILayoutPriority(rawValue: 250)
        let logoImageSize = 100
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
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            
            loginInput.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            loginInput.heightAnchor.constraint(equalToConstant: 50),
            loginInput.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginInput.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            passwordInput.topAnchor.constraint(equalTo: loginInput.bottomAnchor, constant: 0),
            passwordInput.heightAnchor.constraint(equalToConstant: 50),
            passwordInput.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            passwordInput.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.topAnchor.constraint(equalTo: passwordInput.bottomAnchor, constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 16),
            signUpButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
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
            button.backgroundColor = UIColor.createColor(lightMode: UIColor(named: "VkBlue")!, darkMode: UIColor(named: "VkBlue")!)
        } else {
            button.backgroundColor = UIColor.createColor(lightMode: UIColor(ciColor: .gray), darkMode: UIColor.lightGray)
        }
    }
}
