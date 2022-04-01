import UIKit

class FeedViewController: UIViewController, FeedViewDelegate {
    var feedPresenter: FeedPresenter
    var feedView: FeedView?
    
    public init(feedPresenter: FeedPresenter) {
        self.feedPresenter = feedPresenter
        super.init(nibName: nil, bundle: nil)
        self.feedPresenter.setFeedViewDelegate(self)
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
}
