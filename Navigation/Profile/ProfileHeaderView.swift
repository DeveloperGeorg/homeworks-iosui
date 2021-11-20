//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Георгий Бондаренко on 25.10.2021.
//

import UIKit

class ProfileHeaderView: UIView {
    fileprivate let NavBarPadding = 91;
    var profile: Profile
    
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
    
    
    
    public init(profile: Profile, frame: CGRect) {
        self.profile = profile
        super.init(frame: frame)
        print("Profile: \(self.profile.name), \(self.profile.state), \(self.profile.imageSrc)")
        
        let image = UIImage(named: profile.imageSrc)
        avatarImageView.image = image
        let imageSize = 100
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = CGFloat(imageSize / 2)
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        addSubview(avatarImageView)
        avatarImageView.widthAnchor.constraint(equalToConstant: CGFloat(imageSize)).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: CGFloat(imageSize)).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        
        let profileTitleFontSize = 18
        fullNameLabel.font = UIFont.systemFont(ofSize: CGFloat(profileTitleFontSize), weight: .bold)
        fullNameLabel.text = profile.name
        addSubview(fullNameLabel)
        fullNameLabel.heightAnchor.constraint(equalToConstant: CGFloat(profileTitleFontSize)).isActive = true
        fullNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        fullNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16).isActive = true
//
        let profileTextFieldFontSize = 14
        statusLabel.font = UIFont.systemFont(ofSize: CGFloat(profileTextFieldFontSize), weight: .regular)
        statusLabel.text = profile.state
        addSubview(statusLabel)
        statusLabel.heightAnchor.constraint(equalToConstant: CGFloat(profileTextFieldFontSize)).isActive = true
        statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -18).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16).isActive = true
        
        addSubview(statusTextField)
        statusTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        statusTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16).isActive = true
        statusTextField.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16).isActive = true

        addSubview(setStatusButton)
        setStatusButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        setStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 16).isActive = true
        setStatusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
