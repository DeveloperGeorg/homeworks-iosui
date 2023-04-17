import UIKit

class CustomTextInputWithLabel: CustomTextInput {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }

    required init?(coder: NSCoder) {
         super.init(coder: coder)
        setupTextField()
    }

    internal override func setupTextField() {
        super.setupTextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.bottomAnchor.constraint(equalTo: topAnchor, constant: -8).isActive = true
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
    }
}
