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
    
    var planetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = .black
        label.text = "[Planet data]"
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
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
        addSubview(planetLabel)
        configureLayout()
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 70),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            taskLabel.heightAnchor.constraint(equalToConstant: 50),
            taskLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 16),
            taskLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            taskLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            planetLabel.heightAnchor.constraint(equalToConstant: 50),
            planetLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 16),
            planetLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            planetLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder) has not been implemented")
    }
}
