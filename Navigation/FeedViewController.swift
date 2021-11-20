//
//  FeedViewController.swift
//  Navigation
//
//  Created by Георгий Бондаренко on 21.10.2021.
//

import UIKit

class FeedViewController: UIViewController {
    weak var parentNavigationController: UINavigationController?
    
    public init(parentNavigationController: UINavigationController?) {
        super.init(nibName: nil, bundle: nil)
        self.parentNavigationController = parentNavigationController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        let post = self.getPost()
        let view = FeedView(post: post, frame: CGRect())
        let buttons: [UIButton] = view.postsStackView.arrangedSubviews.compactMap{$0 as? UIButton}
        buttons.forEach { (button) in
            button.addTarget(self, action: #selector(openPost), for: .touchUpInside)
        }
        self.view = view
    }
    
    @objc private func openPost() {
        parentNavigationController?.pushViewController(PostViewController(post: self.getPost()), animated: true)
    }
    
    private func getPost()->Post {
        return Post(title: "Post title")
    }
}
