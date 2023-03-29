import UIKit
import SnapKit

class ProfileHeaderView: UIView {
    fileprivate let NavBarPadding = 91
    fileprivate let profileTitleFontSize = 18
    fileprivate let profileTextFieldFontSize = 14
    fileprivate let imageSize = 100
    
    private let profileCoordinator: ProfileCoordinator

    var profile: BloggerPreview?
    
    var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        return avatarImageView
    }()
    
    var fullNameLabel: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        return fullNameLabel
    }()
    
    var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.textColor = UIColor.createColor(lightMode: .gray, darkMode: .lightGray)
        
        return statusLabel
    }()
    
    var statusTextField: UITextField = {
        let statusTextField = UITextField()
        statusTextField.backgroundColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        statusTextField.layer.cornerRadius = 12
        statusTextField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        statusTextField.textColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        statusTextField.layer.borderColor = UIColor.createColor(lightMode: .black, darkMode: .white).cgColor
        statusTextField.layer.borderWidth = 1
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        statusTextField.leftView = paddingView
        statusTextField.leftViewMode = .always
        
        return statusTextField
    }()
    
    var setStatusButton: CustomButton = {
        let button = CustomButton(
            title: String(localized: "Set status"),
            titleColor: UIColor.createColor(lightMode: .white, darkMode: .black),
            titleFor: .normal,
            buttonTappedCallback: nil
        )
        button.layer.cornerRadius = 4
        button.backgroundColor = UIColor.createColor(
            lightMode: UIColor(red: CGFloat(0.0/0.0), green: CGFloat(122.0/255.0), blue: CGFloat(254.0/255.0), alpha: CGFloat(1.0)),
            darkMode: UIColor(red: CGFloat(0.0/0.0), green: CGFloat(122.0/255.0), blue: CGFloat(254.0/255.0), alpha: CGFloat(1.0))
        )
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = UIColor.createColor(lightMode: .black, darkMode: .white).cgColor
        button.layer.shadowRadius = CGFloat(4)
        
        return button
    }()
    
    var createPostButton: CustomButton = {
        let button = CustomButton(
            title: String(localized: "Create post"),
            titleColor: UIColor.createColor(lightMode: .white, darkMode: .black),
            titleFor: .normal,
            buttonTappedCallback: nil
        )
        button.layer.cornerRadius = 4
        button.backgroundColor = UIColor.createColor(
            lightMode: UIColor(red: CGFloat(0.0/0.0), green: CGFloat(122.0/255.0), blue: CGFloat(254.0/255.0), alpha: CGFloat(1.0)),
            darkMode: UIColor(red: CGFloat(0.0/0.0), green: CGFloat(122.0/255.0), blue: CGFloat(254.0/255.0), alpha: CGFloat(1.0))
        )
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = UIColor.createColor(lightMode: .black, darkMode: .white).cgColor
        button.layer.shadowRadius = CGFloat(4)
        
        return button
    }()
    
    public init(profile: BloggerPreview?, frame: CGRect, profileCoordinator: ProfileCoordinator) {
        self.profile = profile
        self.profileCoordinator = profileCoordinator
        super.init(frame: frame)
        
        /** @ todo set default */
        if let imageLink = profile?.imageLink {
            DispatchQueue.global().async { [weak self] in
                if let url = URL(string: imageLink) {
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.avatarImageView.image = image
                            }
                        }
                    }
                }
            }
        }
        
        fullNameLabel.font = UIFont.systemFont(ofSize: CGFloat(profileTitleFontSize), weight: .bold)
        fullNameLabel.text = profile?.name
        
        statusLabel.font = UIFont.systemFont(ofSize: CGFloat(profileTextFieldFontSize), weight: .regular)
        statusLabel.text = profile?.shortDescription
        
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
        addSubview(createPostButton)
        
    }
    
    private func activateConstraints() {
        avatarImageView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(CGFloat(imageSize))
            make.top.leading.equalTo(self).inset(16)
        }
        fullNameLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(CGFloat(profileTitleFontSize))
            make.trailing.equalTo(self).offset(16)
            make.top.equalTo(self).inset(16)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
        }
        statusLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(CGFloat(profileTextFieldFontSize))
            make.trailing.equalTo(self).offset(16)
            make.bottom.equalTo(avatarImageView).inset(18)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
        }
        statusTextField.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.trailing.equalTo(self).inset(16)
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
        }
        setStatusButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.trailing.equalTo(self).inset(16)
            make.top.equalTo(statusTextField.snp.bottom).offset(16)
            make.leading.equalTo(self).inset(16)
        }
        createPostButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.trailing.equalTo(self).inset(16)
            make.top.equalTo(setStatusButton.snp.bottom).offset(16)
            make.leading.equalTo(self).inset(16)
        }
    }
    
    private func drawLayer() {
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = CGFloat(imageSize / 2)
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.createColor(lightMode: .black, darkMode: .white).cgColor
    }
    
    private func addTargets() {
        setStatusButton.setButtonTappedCallback({ sender in
            self.statusLabel.text = self.profile?.shortDescription
            self.statusLabel.setNeedsDisplay()
        })
        createPostButton.setButtonTappedCallback({ sender in
            self.profileCoordinator.createPost()
        })
        statusTextField.addTarget(self, action: #selector(changeProfileState), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func changeProfileState(_ textField: UITextField)
    {
        profile?.shortDescription = String((textField.text ?? profile?.shortDescription) ?? "")
    }
}
