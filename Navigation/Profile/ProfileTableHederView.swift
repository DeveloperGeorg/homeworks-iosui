import UIKit

class ProfileTableHederView: UIView {
    let profileHeaderView: ProfileHeaderView

    public init(profile: User, frame: CGRect, profileCoordinator: ProfileCoordinator) {
        profileHeaderView = ProfileHeaderView(
            profile: profile,
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
