//
//  PostViewController.swift
//  Navigation
//
//  Created by Георгий Бондаренко on 21.10.2021.
//

import UIKit

class PostViewController: UIViewController {
    let postTitle: String
    
    public init(postTitle: String) {
        self.postTitle = postTitle
        super.init(nibName: nil, bundle: nil)
        let infoButtonItem = UIBarButtonItem(
            title: "Info",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(showInfoModal)
        )
        navigationItem.rightBarButtonItem = infoButtonItem
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = postTitle
        view.backgroundColor = .white
    }
    
    @objc private func showInfoModal() {
        let infoModal = InfoViewController()
        present(infoModal, animated: true, completion: nil)
    }
}
