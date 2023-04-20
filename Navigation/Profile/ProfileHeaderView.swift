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
        fullNameLabel.textColor = UiKitFacade.shared.getPrimaryTextColor()
        fullNameLabel.font = UiKitFacade.shared.getPrimaryTitleFont()
        return fullNameLabel
    }()
    
    var shortDescriptionLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.textColor = UiKitFacade.shared.getSecondaryTextColor()
        statusLabel.font = UiKitFacade.shared.getQuaternaryTitleFont()
        
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
            titleColor: UiKitFacade.shared.getTextActionButtonColor(),
            titleFor: .normal,
            buttonTappedCallback: nil
        )
        button.layer.cornerRadius = 4
        button.backgroundColor = UiKitFacade.shared.getBackgroundActionButtonAnabledColor()
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
        
        if let imageLink = profile?.imageLink {
            self.imageService.getUIImageByUrlString(imageLink) { uiImage in
                self.avatarImageView.image = uiImage
            }
        }
        
        fullNameLabel.text = profile?.name
        
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
            make.top.leading.equalTo(self).inset(UiKitFacade.shared.getConstraintContant(2))
        }
        fullNameLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(CGFloat(profileTitleFontSize))
            make.trailing.equalTo(self).offset(UiKitFacade.shared.getConstraintContant(2))
            make.top.equalTo(self).inset(UiKitFacade.shared.getConstraintContant(2))
            make.leading.equalTo(avatarImageView.snp.trailing).offset(UiKitFacade.shared.getConstraintContant(2))
        }
        shortDescriptionLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(CGFloat(profileTextFieldFontSize))
            make.trailing.equalTo(self).offset(UiKitFacade.shared.getConstraintContant(2))
            make.bottom.equalTo(avatarImageView).inset(UiKitFacade.shared.getConstraintContant(2))
            make.leading.equalTo(avatarImageView.snp.trailing).offset(UiKitFacade.shared.getConstraintContant(2))
        }
        editProfileButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(UiKitFacade.shared.getConstraintContant(6))
            make.trailing.equalTo(self).inset(UiKitFacade.shared.getConstraintContant(2))
            make.top.equalTo(avatarImageView.snp.bottom).offset(UiKitFacade.shared.getConstraintContant(2))
            make.leading.equalTo(self).inset(UiKitFacade.shared.getConstraintContant(2))
        }
        createPostButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(UiKitFacade.shared.getConstraintContant(6))
            make.trailing.equalTo(self).inset(UiKitFacade.shared.getConstraintContant(2))
            make.top.equalTo(editProfileButton.snp.bottom).offset(UiKitFacade.shared.getConstraintContant(2))
            make.leading.equalTo(self).inset(UiKitFacade.shared.getConstraintContant(2))
        }
    }
    
    private func drawLayer() {
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = CGFloat(imageSize / 2)
        avatarImageView.layer.borderWidth = 2
        avatarImageView.layer.borderColor = UiKitFacade.shared.getAccentColor().cgColor
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
