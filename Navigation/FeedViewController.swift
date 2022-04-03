import UIKit

class FeedViewController: UIViewController {
    fileprivate let postTitle = "Post title"
    weak var parentNavigationController: UINavigationController?
    var newPostValidator: NewPostValidator = NewPostValidator()
    var feedView: FeedView = FeedView(postTitle: "", frame: .zero)
    
    
    
    public init(parentNavigationController: UINavigationController?) {
        super.init(nibName: nil, bundle: nil)
        self.parentNavigationController = parentNavigationController
        NotificationCenter.default.addObserver(self, selector: #selector(validateNewPost(notification:)), name: NSNotification.Name(rawValue: "NewPostTitleWasUpdated"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        feedView = FeedView(postTitle: postTitle, frame: CGRect())
        let buttons: [CustomButton] = feedView.postsStackView.arrangedSubviews.compactMap{$0 as? CustomButton}
        buttons.forEach { (button) in
            button.setButtonTappedCallback({ sender in
                self.parentNavigationController?.pushViewController(PostViewController(postTitle: self.postTitle), animated: true)
            })
        }
        feedView.validatePostButton.setButtonTappedCallback({ sender in
            self.newPostValidator.title = self.feedView.newPostTitleField.text ?? ""
        })
        self.view = feedView
    }
    
    @objc func validateNewPost(notification: NSNotification) {
        if let newPostData = notification.userInfo?["newPostData"] as? NewPostValidator {
            if newPostData.check(title: newPostData.title) {
                self.feedView.setNewPostTitleLabelIsValid()
            } else {
                self.feedView.setNewPostTitleLabelIsNotValid()
            }
          }
    }
}
