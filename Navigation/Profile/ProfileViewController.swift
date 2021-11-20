//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Георгий Бондаренко on 21.10.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    var profileHeaderView: ProfileHeaderView?
    var profile: Profile = {
        return Profile(name: "Hipster cat", imageSrc: "cat-avatar.png", state: "some state")
    }()
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let profileHeaderView = ProfileHeaderView(
            profile: self.profile,
            frame: view.frame
        )
        profileHeaderView.setStatusButton.addTarget(self, action: #selector(printProfileState), for: .touchUpInside)
        profileHeaderView.stateTextField.addTarget(self, action: #selector(changeProfileState), for: .editingChanged)
        view.addSubview(profileHeaderView)
        self.profileHeaderView = profileHeaderView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        self.title = "Profile"
    }
    
    @objc private func printProfileState()
    {
        self.profileHeaderView?.profileStateLabel.text = profile.state
        self.profileHeaderView?.profileStateLabel.setNeedsDisplay()
    }
    
    @objc private func changeProfileState(_ textField: UITextField)
    {
        profile.state = String(textField.text ?? profile.state)
        print(profile.state)
    }
}
