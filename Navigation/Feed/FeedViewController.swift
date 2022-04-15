import UIKit

class FeedViewController: UIViewController, FeedViewDelegate {
    var feedPresenter: FeedPresenter
    var feedView: FeedView?
    var newPostValidator: NewPostValidator = NewPostValidator()
    
    public init(feedPresenter: FeedPresenter) {
        self.feedPresenter = feedPresenter
        super.init(nibName: nil, bundle: nil)
        self.feedPresenter.setFeedViewDelegate(self)
        NotificationCenter.default.addObserver(self, selector: #selector(validateNewPost(notification:)), name: NSNotification.Name(rawValue: "NewPostTitleWasUpdated"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        feedView = FeedView(frame: CGRect())
        self.feedPresenter.render()
        
        feedView?.validatePostButton.setButtonTappedCallback({ sender in
            self.newPostValidator.title = self.feedView?.newPostTitleField.text ?? ""
        })
        self.view = feedView
    }
    
    @objc private func openPost(_ sender: UIButton) {
        let buttonTitle = sender.currentTitle!
        feedPresenter.openPost(postTitle: buttonTitle)
    }
    
    func addPostToFeed(title: String) -> Void {
        let button = feedView?.getButtonWithText(title)
        guard let postButton = button else {
            return
        }
        postButton.addTarget(self, action: #selector(openPost(_:)), for: .touchUpInside)
        feedView?.postsStackView.addArrangedSubview(postButton)
    }
    
    func setOverworkAlertTimerCounter(_ seconds: Int) -> Void {
        feedView?.setOverworkAlertTimerCounter(seconds)
    }

    @objc func validateNewPost(notification: NSNotification) {
        if let newPostData = notification.userInfo?["newPostData"] as? NewPostValidator {
            if newPostData.check(title: newPostData.title) {
                self.feedView?.setNewPostTitleLabelIsValid()
            } else {
                self.feedView?.setNewPostTitleLabelIsNotValid()
            }
          }
    }
}
