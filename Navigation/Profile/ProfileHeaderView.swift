import UIKit

class ProfileHeaderView: UIView {
    fileprivate let NavBarPadding = 91
    fileprivate let profileTitleFontSize = 18
    fileprivate let profileTextFieldFontSize = 14
    fileprivate let imageSize = 100

    var profile: User
    
    var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        return avatarImageView
    }()
    
    var fullNameLabel: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.textColor = .black
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return fullNameLabel
    }()
    
    var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.textColor = .gray
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return statusLabel
    }()
    
    var statusTextField: UITextField = {
        let statusTextField = UITextField()
        statusTextField.translatesAutoresizingMaskIntoConstraints = false
        statusTextField.backgroundColor = .white
        statusTextField.layer.cornerRadius = 12
        statusTextField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        statusTextField.textColor = .black
        statusTextField.layer.borderColor = UIColor.black.cgColor
        statusTextField.layer.borderWidth = 1
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        statusTextField.leftView = paddingView
        statusTextField.leftViewMode = .always
        
        return statusTextField
    }()
    
    var setStatusButton: UIButton = {
        let showStatusButton = UIButton()
        showStatusButton.translatesAutoresizingMaskIntoConstraints = false
        showStatusButton.layer.cornerRadius = 4
        showStatusButton.backgroundColor = UIColor(red: CGFloat(0.0/0.0), green: CGFloat(122.0/255.0), blue: CGFloat(254.0/255.0), alpha: CGFloat(1.0))
        showStatusButton.setTitleColor(.white, for: .normal)
        showStatusButton.setTitle("Set status", for: .normal)
        showStatusButton.layer.shadowOpacity = 0.7
        showStatusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        showStatusButton.layer.shadowColor = UIColor.black.cgColor
        showStatusButton.layer.shadowRadius = CGFloat(4)
        
        return showStatusButton
    }()
    
    public init(profile: User, frame: CGRect) {
        self.profile = profile
        super.init(frame: frame)
        
        let image = UIImage(named: profile.avatarImageSrc)
        avatarImageView.image = image
        
        fullNameLabel.font = UIFont.systemFont(ofSize: CGFloat(profileTitleFontSize), weight: .bold)
        fullNameLabel.text = profile.fullName
        
        statusLabel.font = UIFont.systemFont(ofSize: CGFloat(profileTextFieldFontSize), weight: .regular)
        statusLabel.text = profile.status
        
        addSubviews()
        drawLayer()
        activateConstraints()
        addTargets()
    }
    
    private func addSubviews() {
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(setStatusButton)
        
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: CGFloat(imageSize)),
            avatarImageView.heightAnchor.constraint(equalToConstant: CGFloat(imageSize)),
            avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            fullNameLabel.heightAnchor.constraint(equalToConstant: CGFloat(profileTitleFontSize)),
            fullNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            fullNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            
            statusLabel.heightAnchor.constraint(equalToConstant: CGFloat(profileTextFieldFontSize)),
            statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            statusLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -18),
            statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            
            statusTextField.heightAnchor.constraint(equalToConstant: 40),
            statusTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16),
            statusTextField.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),

            setStatusButton.heightAnchor.constraint(equalToConstant: 50),
            setStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 16),
            setStatusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
        ])
    }
    
    private func drawLayer() {
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = CGFloat(imageSize / 2)
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func addTargets() {
        setStatusButton.addTarget(self, action: #selector(printProfileState), for: .touchUpInside)
        statusTextField.addTarget(self, action: #selector(changeProfileState), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func printProfileState()
    {
        statusLabel.text = profile.status
        statusLabel.setNeedsDisplay()
    }
    
    @objc private func changeProfileState(_ textField: UITextField)
    {
        profile.status = String(textField.text ?? profile.status)
    }
}
