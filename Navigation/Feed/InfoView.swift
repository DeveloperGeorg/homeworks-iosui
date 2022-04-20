import UIKit

class InfoView: UIView {
    var button: CustomButton = {
        let button = CustomButton(title: "", titleColor: .red, titleFor: .normal, buttonTappedCallback: nil)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black
        label.text = "[Task title]"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
        self.isOpaque = false
        button.setTitle("Show alert", for: .normal)
        addSubview(button)
        addSubview(taskLabel)
        configureLayout()
    }
    
    func configureLayout() {
//        let views: [String: Any] = [
//            "superView": self,
//            "button": button,
//            "taskLabel": taskLabel
//        ]
//
//        let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[button(120)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
//        let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[button(70)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
//        let horizontalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
//        let verticalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
//        NSLayoutConstraint.activate(widthConstraints)
//        NSLayoutConstraint.activate(heightConstraints)
//        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
//
//
//        let labelWidthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[taskLabel(120)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
//        let labelHeightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[taskLabel(70)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
//        let labelHorizontalConstraint = NSLayoutConstraint(item: taskLabel, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
//        let labelVerticalConstraint = NSLayoutConstraint(item: taskLabel, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 20)
//        NSLayoutConstraint.activate(labelWidthConstraints)
//        NSLayoutConstraint.activate(labelHeightConstraints)
//        NSLayoutConstraint.activate([labelHorizontalConstraint, labelVerticalConstraint])

        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 70),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            taskLabel.heightAnchor.constraint(equalToConstant: 50),
            taskLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 16),
            taskLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            taskLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder) has not been implemented")
    }
}
