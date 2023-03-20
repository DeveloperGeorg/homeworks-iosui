import UIKit

class InfoView: UIView {
    var button: CustomButton = {
        let button = CustomButton(title: "", titleColor: .red, titleFor: .normal, buttonTappedCallback: nil)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
        self.isOpaque = false
        button.setTitle(String(localized: "Show alert"), for: .normal)
        addSubview(button)
        configureLayout()
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 70),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder) has not been implemented")
    }
}
