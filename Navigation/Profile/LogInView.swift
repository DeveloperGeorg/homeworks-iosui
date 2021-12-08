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
        loginInput.backgroundColor = UIColor(red: CGFloat(242.0/255.0), green: CGFloat(242.0/255.0), blue: CGFloat(247.0/255.0), alpha: CGFloat(1.0))
        loginInput.textColor = .gray
        loginInput.layer.borderColor = UIColor.lightGray.cgColor
        loginInput.layer.borderWidth = 0.5
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        loginInput.leftView = paddingView
        loginInput.leftViewMode = .always
        
        loginInput.placeholder = "Email or phone"
        
        return loginInput
    }()
    
    let passwordInput: UITextField = {
        let passwordInput = UITextField()
        passwordInput.translatesAutoresizingMaskIntoConstraints = false
        passwordInput.backgroundColor = UIColor(red: CGFloat(242.0/255.0), green: CGFloat(242.0/255.0), blue: CGFloat(247.0/255.0), alpha: CGFloat(1.0))
        passwordInput.textColor = .gray
        passwordInput.layer.borderColor = UIColor.lightGray.cgColor
        passwordInput.layer.borderWidth = 0.5
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        passwordInput.leftView = paddingView
        passwordInput.leftViewMode = .always
        
        passwordInput.placeholder = "Password"
        passwordInput.isSecureTextEntry = true
        
        return passwordInput
    }()
    
    
    let logInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "VkBlue") 
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Log In", for: .normal)

        return button
    }()
    
    fileprivate enum CellReuseID: String {
        case login = "loginReuseID"
        case password = "passwordReuseID"
    }
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        addSubviews()
        activateConstraints()
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
        ])
        
        loginInput.layer.cornerRadius = 20
        loginInput.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        passwordInput.layer.cornerRadius = 20
        passwordInput.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
    }
}
