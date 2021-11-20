//
//  InfoViewController.swift
//  Navigation
//
//  Created by Георгий Бондаренко on 24.10.2021.
//

import UIKit

class InfoViewController: UIViewController {
    var alert: UIAlertController = {
        let alert = UIAlertController(title: "My Alert", message: "This is an alert.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            UIAlertAction in
            print("Pressed OK action")
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {
            UIAlertAction in
            print("Pressed Cancel action")
        }
        alert.addAction(cancelAction)
        return alert
    }()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    }
    override func loadView() {
        let view = InfoView()
        self.view = view
        view.button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func showAlert()
    {
        present(alert, animated: true, completion: nil)
    }
}
