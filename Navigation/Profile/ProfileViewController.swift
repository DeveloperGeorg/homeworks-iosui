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
    
    
    var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.backgroundColor = UIColor(red: CGFloat(0.0/0.0), green: CGFloat(122.0/255.0), blue: CGFloat(254.0/255.0), alpha: CGFloat(1.0))
        button.setTitleColor(.white, for: .normal)
        button.setTitle("New button", for: .normal)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = CGFloat(4)
        
        return button
    }()
    
//    override func loadView() {
//        let profileHeaderView = ProfileHeaderView(
//            profile: self.profile,
//            frame: .zero
//        )
//        profileHeaderView.setStatusButton.addTarget(self, action: #selector(printProfileState), for: .touchUpInside)
//        profileHeaderView.statusTextField.addTarget(self, action: #selector(changeProfileState), for: .editingChanged)
//        self.profileHeaderView = profileHeaderView
//        view.addSubview(profileHeaderView)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        self.title = "Profile"
        let profileHeaderView = ProfileHeaderView(
            profile: self.profile,
            frame: .zero
        )
        
        profileHeaderView.setStatusButton.addTarget(self, action: #selector(printProfileState), for: .touchUpInside)
        profileHeaderView.statusTextField.addTarget(self, action: #selector(changeProfileState), for: .editingChanged)
        self.profileHeaderView = profileHeaderView
        view.addSubview(profileHeaderView)
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        
        view.addSubview(button)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    @objc private func printProfileState()
    {
        self.profileHeaderView?.statusLabel.text = profile.state
        self.profileHeaderView?.statusLabel.setNeedsDisplay()
    }
    
    @objc private func changeProfileState(_ textField: UITextField)
    {
        profile.state = String(textField.text ?? profile.state)
        print(profile.state)
    }
}
