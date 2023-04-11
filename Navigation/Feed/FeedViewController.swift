import UIKit

class FeedViewController: UIViewController, FeedViewDelegate {
    var feedPresenter: FeedPresenter
    var feedView: FeedView?
    var newPostValidator: NewPostValidator = NewPostValidator()
    var postListTableViewDataSource = PostListTableViewDataSource()
    let postDataProviderProtocol: PostAggregateDataProviderProtocol
    let postLikeDataProvider: PostLikeDataProviderProtocol
    let postCommentDataProvider: PostCommentDataProviderProtocol
    let paginationLimit = 3;
    var couldGetNextPage = true
    let refreshControl = UIRefreshControl()
    
    let temporaryBloggerId = "5WSoAxbM6IVfobdPRpAU3PpA0wO2"
    
    public init(feedPresenter: FeedPresenter) {
        self.feedPresenter = feedPresenter
        self.postDataProviderProtocol = FirestorePostAggregateDataProvider()
        self.postLikeDataProvider = FirestorePostLikeDataProvider()
        self.postCommentDataProvider = FirestorePostCommentDataProvider()
        self.postListTableViewDataSource.setCurrentBloggerId(self.temporaryBloggerId)
        self.postListTableViewDataSource.setPostLikeDataStorage(FirestorePostLikeDataStorage())
        self.postListTableViewDataSource.setPostFavoritesDataStorage(FirestorePostFavoritesDataStorage())
        super.init(nibName: nil, bundle: nil)
        self.feedPresenter.setFeedViewDelegate(self)
        NotificationCenter.default.addObserver(self, selector: #selector(validateNewPost(notification:)), name: NSNotification.Name(rawValue: "NewPostTitleWasUpdated"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        postDataProviderProtocol.getList(limit: paginationLimit, beforePostedAtFilter: nil, bloggerIdFilter: nil, currentBloggerId: temporaryBloggerId) { posts, hasMore in
            self.couldGetNextPage = hasMore
            self.postListTableViewDataSource.addPosts(posts)
            self.feedView?.postsTableView.reloadData()
        }
    }
    
    override func loadView() {
        feedView = FeedView(frame: CGRect())
        feedView?.postsTableView.dataSource = postListTableViewDataSource
        feedView?.postsTableView.delegate = self
        feedView?.postsTableView.rowHeight = UITableView.automaticDimension
        feedView?.postsTableView.register(PostItemTableViewCell.self, forCellReuseIdentifier: postListTableViewDataSource.forCellReuseIdentifier)
        
        refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Pull to refresh"))
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        feedView?.postsTableView.addSubview(refreshControl)
        
        self.feedPresenter.render()
        
        feedView?.validatePostButton.setButtonTappedCallback({ sender in
            self.newPostValidator.title = self.feedView?.newPostTitleField.text ?? ""
        })
        self.view = feedView
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Start refreshing"))
        postDataProviderProtocol.getList(limit: paginationLimit, beforePostedAtFilter: nil, bloggerIdFilter: nil, currentBloggerId: temporaryBloggerId) { posts, hasMore in
            self.couldGetNextPage = hasMore
            self.postListTableViewDataSource.clearPosts()
            self.postListTableViewDataSource.addPosts(posts)
            self.feedView?.postsTableView.reloadData()
            self.refreshControl.endRefreshing()
            self.refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Pull to refresh"))
        }
    }
    
    func addPostToFeed(title: String) -> Void {
        let button = feedView?.getButtonWithText(title)
        guard let postButton = button else {
            return
        }
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
        let post = self.postListTableViewDataSource.posts[row]
        feedPresenter.openPost(post: post)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = Int(indexPath.row)
        if postListTableViewDataSource.posts.endIndex-1 == index {
            if self.couldGetNextPage {
                print("load new data..")
                var beforePostedAtFilter: Date? = nil
                if let lastPost = postListTableViewDataSource.posts.last {
                    beforePostedAtFilter = lastPost.post.postedAt
                }
                postDataProviderProtocol.getList(limit: paginationLimit, beforePostedAtFilter: beforePostedAtFilter, bloggerIdFilter: nil, currentBloggerId: temporaryBloggerId) { posts, hasMore in
                    self.couldGetNextPage = hasMore
                    self.postListTableViewDataSource.addPosts(posts)
                    self.feedView?.postsTableView.reloadData()
                }
            }
        }

    }
}
