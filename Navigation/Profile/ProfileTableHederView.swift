import UIKit

class ProfileTableHederView: UIView {
    let profileHeaderView: ProfileHeaderView
    
    var profile: BloggerPreview?

    public init(profile: BloggerPreview?, frame: CGRect, profileCoordinator: ProfileCoordinator) {
        self.profile = profile
        profileHeaderView = ProfileHeaderView(
            profile: self.profile,
            frame: .zero,
            profileCoordinator: profileCoordinator
        )
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        
        addSubviews()
        activateConstraints()
    }
    
    private func addSubviews() {
        addSubview(profileHeaderView)
    }
    
    private func activateConstraints() {
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileHeaderView.heightAnchor.constraint(equalToConstant: 290),
            profileHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            profileHeaderView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
