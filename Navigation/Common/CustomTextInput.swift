import UIKit

class CustomTextInput: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }

    required init?(coder: NSCoder) {
         super.init(coder: coder)
        setupTextField()
    }

    internal func setupTextField() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UiKitFacade.shared.getSecondaryBackgroundColor()
        self.layer.cornerRadius = UiKitFacade.shared.getConstraintContant(1.5)
        self.font = UiKitFacade.shared.getRegularTextFont()
        self.textColor = UiKitFacade.shared.getSecondaryTextColor()
        self.layer.borderColor = UiKitFacade.shared.getBackgroundActionButtonAnabledColor().cgColor
        self.layer.borderWidth = 1
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UiKitFacade.shared.getConstraintContant(1.5), height: UiKitFacade.shared.getConstraintContant(5)))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
