//
//  FeedView.swift
//  Navigation
//
//  Created by Георгий Бондаренко on 21.10.2021.
//

import UIKit

class FeedView: UIView {
    
    var buttonView: UIView = {
        let buttonView = UIView()
        buttonView.backgroundColor = .red
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        return buttonView;
    }()
    var button: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .white
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    public init(post: Post, frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        addSubview(buttonView)
        button.setTitle(post.title, for: .normal)
        buttonView.addSubview(button)
        configureLayout()
        
    }
    
    func configureLayout() {
        let views: [String: Any] = [
            "superView": self,
            "buttonView": buttonView,
            "button": button
        ]
        var constraintArray: [NSLayoutConstraint] = []
        
        constraintArray += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[buttonView]-|", metrics: nil, views: views)
        constraintArray += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[buttonView]-|", metrics: nil, views: views)
        constraintArray += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[button]|", metrics: nil, views: views)
        constraintArray += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[button]|", metrics: nil, views: views)
        NSLayoutConstraint.activate(constraintArray)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder) has not been implemented")
    }
}
