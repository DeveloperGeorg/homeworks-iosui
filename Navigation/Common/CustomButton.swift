import UIKit

class CustomButton: UIButton {
    private var buttonTappedCallback: (_ sender:UIButton) -> Void = { sender in
        print("Button was tapped")
    }
    init(title: String, titleColor: UIColor, titleFor: UIControl.State, buttonTappedCallback: ( (_ sender:UIButton) -> Void)?) {
        if let buttonTappedClouseres = buttonTappedCallback {
            self.buttonTappedCallback = buttonTappedClouseres
        }
        super.init(frame: .zero)
        setTitleColor(titleColor, for: titleFor)
        setTitle(title, for: titleFor)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    public func setButtonTappedCallback(_ buttonTappedCallback: @escaping (_ sender:UIButton) -> Void) {
        self.buttonTappedCallback = buttonTappedCallback
    }
    
    @objc private func buttonTapped(sender:UIButton) {
        self.buttonTappedCallback(sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
