import UIKit

class ProfileTableHederView: UIView {
    var profile: Profile = {
        return Profile(name: "Hipster cat", imageSrc: "cat-avatar.png", state: "some state")
    }()
    let profileHeaderView: ProfileHeaderView

    public override init(frame: CGRect) {
        profileHeaderView = ProfileHeaderView(
            profile: profile,
            frame: .zero
        )
        super.init(frame: frame)
        
        self.backgroundColor = .lightGray
        
        addSubviews()
        activateConstraints()
    }
    
    private func addSubviews() {
        addSubview(profileHeaderView)
    }
    
    private func activateConstraints() {
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileHeaderView.heightAnchor.constraint(equalToConstant: 220),
            profileHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            profileHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            profileHeaderView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
