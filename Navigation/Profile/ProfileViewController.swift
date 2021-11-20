//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Георгий Бондаренко on 21.10.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    let profile: Profile = {
        return Profile(name: "Hipster cat", imageSrc: "cat-avatar.png", state: "some state")
    }()
    
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let profileHeaderView = ProfileHeaderView(
            profile: self.profile,
            frame: view.frame
        )
        profileHeaderView.showStatusButton.addTarget(self, action: #selector(printProfileState), for: .touchUpInside)
        view.addSubview(profileHeaderView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        self.title = "Profile"
    }
    
    @objc private func printProfileState()
    {
        print(profile.state)
    }
}
