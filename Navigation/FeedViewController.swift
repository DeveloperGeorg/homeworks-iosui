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
        let buttons: [CustomButton] = view.postsStackView.arrangedSubviews.compactMap{$0 as? CustomButton}
        buttons.forEach { (button) in
            button.setButtonTappedCallback({ sender in
                self.parentNavigationController?.pushViewController(PostViewController(postTitle: self.postTitle), animated: true)
            })
        }
        self.view = view
    }
}
