import UIKit

class FeedViewController: UIViewController {
    fileprivate let postTitle = "Post title"
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
        let view = FeedView(postTitle: postTitle, frame: CGRect())
        let buttons: [UIButton] = view.postsStackView.arrangedSubviews.compactMap{$0 as? UIButton}
        buttons.forEach { (button) in
            button.addTarget(self, action: #selector(openPost), for: .touchUpInside)
        }
        self.view = view
    }
    
    @objc private func openPost() {
        parentNavigationController?.pushViewController(PostViewController(postTitle: postTitle), animated: true)
    }
}
