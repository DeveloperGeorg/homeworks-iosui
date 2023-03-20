import UIKit
import SnapKit

class FeedView: UIView {
    var postsStackView: UIStackView = {
        let postsStackView = UIStackView()
        postsStackView.translatesAutoresizingMaskIntoConstraints = false
        postsStackView.axis = .vertical
        postsStackView.spacing = 10
        return postsStackView
    }()
    
    var newPostTitleField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    var validatePostButton: CustomButton = {
        let button = CustomButton(title: String(localized: "Validate new post title"), titleColor: .white, titleFor: .normal, buttonTappedCallback: nil)
        button.layer.cornerRadius = 4
        button.backgroundColor = UIColor(red: CGFloat(0.0/0.0), green: CGFloat(122.0/255.0), blue: CGFloat(254.0/255.0), alpha: CGFloat(1.0))
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = CGFloat(4)
        
        return button
    }()
    
    var isNewPostTitleValid: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black
        label.text = String(localized: "Enter the value")
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        
        addSubview(postsStackView)
        postsStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        postsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        addSubview(newPostTitleField)
        newPostTitleField.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.centerX.equalTo(self)
            make.trailing.equalTo(self).inset(32)
            make.top.equalTo(postsStackView.snp.bottom).offset(64)
        }

        addSubview(validatePostButton)
        validatePostButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.centerX.equalTo(self)
            make.trailing.equalTo(self).inset(32)
            make.top.equalTo(newPostTitleField.snp.bottom).offset(16)
        }

        addSubview(isNewPostTitleValid)
        isNewPostTitleValid.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.centerX.equalTo(self)
            make.trailing.equalTo(self).inset(32)
            make.top.equalTo(validatePostButton.snp.bottom).offset(16)
        }
    }
    
    public func getButtonWithText(_ text: String) -> CustomButton {
        let button = CustomButton(title: text, titleColor: .red, titleFor: .normal, buttonTappedCallback: nil)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return button
    }
    
    public func setNewPostTitleLabelIsValid() {
        isNewPostTitleValid.text = String(localized: "Title is valid")
        isNewPostTitleValid.textColor = .green
    }
    
    public func setNewPostTitleLabelIsNotValid() {
        isNewPostTitleValid.text = String(localized: "Title is not valid")
        isNewPostTitleValid.textColor = .red
    }
}
