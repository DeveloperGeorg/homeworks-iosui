//
//  InfoView.swift
//  Navigation
//
//  Created by Георгий Бондаренко on 24.10.2021.
//

import UIKit

class InfoView: UIView {
    var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .white
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
        self.isOpaque = false
        button.setTitle("Show alert", for: .normal)
        addSubview(button)
        configureLayout()
    }
    
    func configureLayout() {
        let views: [String: Any] = [
            "superView": self,
            "button": button
        ]
        
        let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[button(120)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
        let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[button(70)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
        let horizontalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate(widthConstraints)
        NSLayoutConstraint.activate(heightConstraints)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder) has not been implemented")
    }
}
