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
    var showStatusButton: UIButton = UIButton()
    
    public init(profile: Profile, frame: CGRect) {
        self.profile = profile
        super.init(frame: frame)
        print("Profile: \(self.profile.name), \(self.profile.state), \(self.profile.imageSrc)")
        let image = UIImage(named: profile.imageSrc)
        let profileImage = UIImageView()
        profileImage.image = image
        let imageSize = 100
        profileImage.frame = CGRect(origin: CGPoint(x: 16, y: NavBarPadding + 16), size: CGSize(width: imageSize, height: imageSize))
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.white.cgColor
        addSubview(profileImage)

        let textWidth = frame.width - profileImage.frame.maxX - 32
        
        
        let profileTitle = UILabel()
        let profileTitleFontSize = 18
        profileTitle.frame = CGRect(origin: CGPoint(x: Int(profileImage.frame.maxX) + 16, y: NavBarPadding + 27), size: CGSize(width: Int(textWidth), height: profileTitleFontSize))
        profileTitle.font = UIFont.systemFont(ofSize: CGFloat(profileTitleFontSize), weight: .bold)
        profileTitle.textColor = .black
        profileTitle.text = profile.name
        addSubview(profileTitle)
        
        showStatusButton.frame = CGRect(origin: CGPoint(x: 16, y: Int(profileImage.frame.maxY) + 16), size: CGSize(width: frame.width - 32, height: 50))
        showStatusButton.layer.cornerRadius = 4
        showStatusButton.backgroundColor = UIColor(red: CGFloat(0.0/0.0), green: CGFloat(122.0/255.0), blue: CGFloat(254.0/255.0), alpha: CGFloat(1.0))
        showStatusButton.setTitleColor(.white, for: .normal)
        showStatusButton.setTitle("Show status", for: .normal)
        showStatusButton.layer.shadowOpacity = 0.7
        showStatusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        showStatusButton.layer.shadowColor = UIColor.black.cgColor
        showStatusButton.layer.shadowRadius = CGFloat(4)
        addSubview(showStatusButton)
        
        let profileStateLabel = UILabel()
        let profileTextFieldFontSize = 14
        profileStateLabel.frame = CGRect(origin: CGPoint(x: Int(profileImage.frame.maxX) + 16, y: Int(showStatusButton.frame.minY) - (34 + profileTextFieldFontSize)), size: CGSize(width: Int(textWidth), height: profileTextFieldFontSize))
        profileStateLabel.text = profile.state
        profileStateLabel.textColor = .gray
        profileStateLabel.font = UIFont.systemFont(ofSize: CGFloat(profileTextFieldFontSize), weight: .regular)
        addSubview(profileStateLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
