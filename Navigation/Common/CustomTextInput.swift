import UIKit

class CustomTextInput: UITextField {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }

    required init?(coder: NSCoder) {
         super.init(coder: coder)
        setupTextField()
    }

    private func setupTextField() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UiKitFacade.shared.getSecondaryBackgroundColor()
        self.layer.cornerRadius = 12
        self.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        self.textColor = UiKitFacade.shared.getSecondaryTextColor()
        self.layer.borderColor = UiKitFacade.shared.getSecondaryBackgroundColor().cgColor
        self.layer.borderWidth = 1
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        self.leftView = paddingView
        self.leftViewMode = .always
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.bottomAnchor.constraint(equalTo: topAnchor, constant: -8).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
    }
}
