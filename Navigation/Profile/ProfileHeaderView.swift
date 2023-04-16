import UIKit
import SnapKit

class ProfileHeaderView: UIView {
    private let imageService: ImageService = ImageService()
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
    
    var shortDescriptionLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.textColor = UIColor.createColor(lightMode: .gray, darkMode: .lightGray)
        
        return statusLabel
    }()
    
    var editProfileButton: CustomButton = {
        let button = CustomButton(
            title: String(localized: "Edit profile"),
            titleColor: UiKitFacade.shared.getPrimaryTextColor(),
            titleFor: .normal,
            buttonTappedCallback: nil
        )
        button.layer.cornerRadius = 4
        button.backgroundColor = UiKitFacade.shared.getAccentColor()
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
            self.imageService.getUIImageByUrlString(imageLink) { uiImage in
                self.avatarImageView.image = uiImage
            }
        }
        
        fullNameLabel.font = UIFont.systemFont(ofSize: CGFloat(profileTitleFontSize), weight: .bold)
        fullNameLabel.text = profile?.name
        
        shortDescriptionLabel.font = UIFont.systemFont(ofSize: CGFloat(profileTextFieldFontSize), weight: .regular)
        shortDescriptionLabel.text = profile?.shortDescription
        
        addSubviews()
        drawLayer()
        activateConstraints()
        addTargets()
    }
    
    private func addSubviews() {
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(shortDescriptionLabel)
        addSubview(editProfileButton)
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
        shortDescriptionLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(CGFloat(profileTextFieldFontSize))
            make.trailing.equalTo(self).offset(16)
            make.bottom.equalTo(avatarImageView).inset(18)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
        }
        editProfileButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.trailing.equalTo(self).inset(16)
            make.top.equalTo(avatarImageView.snp.bottom).offset(16)
            make.leading.equalTo(self).inset(16)
        }
        createPostButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.trailing.equalTo(self).inset(16)
            make.top.equalTo(editProfileButton.snp.bottom).offset(16)
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
        createPostButton.setButtonTappedCallback({ sender in
            self.profileCoordinator.createPost()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
