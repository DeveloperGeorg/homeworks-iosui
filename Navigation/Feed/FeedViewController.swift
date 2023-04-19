import UIKit

class FeedViewController: UIViewController {
    enum ValidationError: Error {
            case notFound
        }
    var feedCoordinator: FeedCoordinator
    var feedView: FeedView?
    let userService: UserService
    var postListTableViewDataSource = PostListTableViewDataSource()
    let postAggregateService: PostAggregateServiceProtocol
    let postLikeDataProvider: PostLikeDataProviderProtocol
    let postCommentDataProvider: PostCommentDataProviderProtocol
    private let bloggerDataProvider: BloggerDataProviderProtocol
    let paginationLimit = 5;
    var couldGetNextPage = true
    let refreshControl = UIRefreshControl()
    
    var user: User
    var blogger: BloggerPreview? = nil
    
    public init(feedCoordinator: FeedCoordinator, userService: UserService) throws {
        self.feedCoordinator = feedCoordinator
        self.userService = userService
        if let user = self.userService.getUserIfAuthorized() {
            self.user = user
            self.postAggregateService = FirestorePostAggregateService()
            self.postLikeDataProvider = FirestorePostLikeDataProvider()
            self.postCommentDataProvider = FirestorePostCommentDataProvider()
            self.bloggerDataProvider = FirestoreBloggerDataProvider()
            super.init(nibName: nil, bundle: nil)
        } else {
            /** @todo throw and go back */
            throw ValidationError.notFound
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bloggerDataProvider.getByUserId(self.user.userId) { blogger in
            if let blogger = blogger {
                self.blogger = blogger
                self.postListTableViewDataSource.setCurrentBloggerId(blogger.id)
                self.postListTableViewDataSource.setPostLikeDataStorage(FirestorePostLikeDataStorage())
                self.postListTableViewDataSource.setPostFavoritesDataStorage(FirestorePostFavoritesDataStorage())
                self.postListTableViewDataSource.setPostAggregateService(self.postAggregateService)
                if let bloggerId = blogger.id {
                    self.postAggregateService.getList(limit: self.paginationLimit, beforePostedAtFilter: nil, bloggerIdFilter: nil, currentBloggerId: bloggerId) { posts, hasMore in
                        self.couldGetNextPage = hasMore
                        self.postListTableViewDataSource.addPosts(posts)
                        self.feedView?.postsTableView.reloadData()
                    }
                }
            }
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
        
        self.view = feedView
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Start refreshing"))
        if let bloggerId = blogger?.id {
            postAggregateService.getList(limit: paginationLimit, beforePostedAtFilter: nil, bloggerIdFilter: nil, currentBloggerId: bloggerId) { posts, hasMore in
                self.couldGetNextPage = hasMore
                self.postListTableViewDataSource.clearPosts()
                self.postListTableViewDataSource.addPosts(posts)
                self.feedView?.postsTableView.reloadData()
                self.refreshControl.endRefreshing()
                self.refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Pull to refresh"))
            }
        } else {
            self.refreshControl.endRefreshing()
            self.refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Pull to refresh"))
        }
    }
}

/** @todo move to the common place */
extension FeedViewController: UITableViewDelegate {
    func selectedCell(row: Int) {
        /** @todo create and use posts coordinator */
        let post = self.postListTableViewDataSource.posts[row]
        feedCoordinator.openPost(post: post)
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
                if let bloggerId = blogger?.id {
                    postAggregateService.getList(limit: paginationLimit, beforePostedAtFilter: beforePostedAtFilter, bloggerIdFilter: nil, currentBloggerId: bloggerId) { posts, hasMore in
                        self.couldGetNextPage = hasMore
                        self.postListTableViewDataSource.addPosts(posts)
                        self.feedView?.postsTableView.reloadData()
                    }
                }
            }
        }
    }
}
