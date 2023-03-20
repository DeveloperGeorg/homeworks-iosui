import UIKit

class FeedViewController: UIViewController, FeedViewDelegate {
    var feedPresenter: FeedPresenter
    var feedView: FeedView?
    var newPostValidator: NewPostValidator = NewPostValidator()
    var postListTableViewDataSource = PostListTableViewDataSource()
    
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
        feedView?.postsTableView.dataSource = postListTableViewDataSource
        feedView?.postsTableView.delegate = self
        feedView?.postsTableView.rowHeight = UITableView.automaticDimension
        feedView?.postsTableView.register(PostTableViewCell.self, forCellReuseIdentifier: postListTableViewDataSource.forCellReuseIdentifier)
        
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

/** @todo move to the common place */
extension FeedViewController: UITableViewDelegate {
    func selectedCell(row: Int) {
        /** @todo create and use posts coordinator */
        let viewControllerNext = UIViewController()
        viewControllerNext.view.backgroundColor = .systemRed
        
        navigationController?.pushViewController(viewControllerNext, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
