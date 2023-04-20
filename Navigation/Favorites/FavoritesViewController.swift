import UIKit

class FavoritesViewController: UIViewController {
    enum ValidationError: Error {
            case notFound
        }
    var favoritesCoordinator: FavoritesCoordinator
    var feedView: FeedView?
    var postListTableViewDataSource = PostListTableViewDataSource()
    let postAggregateService: PostAggregateServiceProtocol
    private let bloggerDataProvider: BloggerDataProviderProtocol
    let postLikeDataProvider: PostLikeDataProviderProtocol
    let postCommentDataProvider: PostCommentDataProviderProtocol
    let postFavoritesDataProvider: PostFavoritesDataProviderProtocol
    private var userService: UserService
    let paginationLimit = 5;
    var couldGetNextPage = true
    let refreshControl = UIRefreshControl()
    public lazy var spinnerView : PSOverlaySpinner = {
        let loadingView : PSOverlaySpinner = PSOverlaySpinner()
        return loadingView
    }()
    let user: User
    var blogger: BloggerPreview? = nil
    
    public init(favoritesCoordinator: FavoritesCoordinator, userService: UserService) throws {
        self.favoritesCoordinator = favoritesCoordinator
        self.postAggregateService = FirestorePostAggregateService()
        self.postLikeDataProvider = FirestorePostLikeDataProvider()
        self.postCommentDataProvider = FirestorePostCommentDataProvider()
        self.postFavoritesDataProvider = FirestorePostFavoritesDataProvider()
        self.bloggerDataProvider = FirestoreBloggerDataProvider()
        self.userService = userService
        if let user = self.userService.getUserIfAuthorized() {
            self.user = user
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
        self.bloggerDataProvider.getByUserId(user.userId) { blogger in
            if let blogger = blogger {
                self.spinnerView.show()
                self.blogger = blogger
                self.postListTableViewDataSource.setCurrentBloggerId(blogger.id)
                self.postListTableViewDataSource.setPostAggregateService(self.postAggregateService)
                self.postListTableViewDataSource.setPostLikeDataStorage(FirestorePostLikeDataStorage())
                self.postListTableViewDataSource.setPostFavoritesDataStorage(FirestorePostFavoritesDataStorage())
                if let bloggerId = self.blogger?.id {
                    self.postFavoritesDataProvider.getListByBlogger(limit: self.paginationLimit, bloggerIdFilter: bloggerId, beforeAddedAtFilter: nil) { postFavoriteList, hasMoreFavorite in
                        var postIds: [String] = []
                        for postFavorite in postFavoriteList {
                            postIds.append(postFavorite.post)
                        }
                        self.postAggregateService.getListByIds(postIds: postIds, currentBloggerId: bloggerId) { posts, hasMore in
                            self.couldGetNextPage = hasMoreFavorite
                            self.postListTableViewDataSource.addPosts(posts)
                            self.feedView?.postsTableView.reloadData()
                            self.spinnerView.hide()
                        }
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
        
        feedView?.addSubview(spinnerView)
        if let feedView = feedView {
            spinnerView.leadingAnchor.constraint(equalTo: feedView.leadingAnchor).isActive = true
            spinnerView.trailingAnchor.constraint(equalTo: feedView.trailingAnchor).isActive = true
            spinnerView.topAnchor.constraint(equalTo: feedView.topAnchor).isActive = true
            spinnerView.bottomAnchor.constraint(equalTo: feedView.bottomAnchor).isActive = true
        }
        
        self.view = feedView
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Start refreshing"))
        if let bloggerId = self.blogger?.id {
            self.spinnerView.show()
            self.postFavoritesDataProvider.getListByBlogger(limit: paginationLimit, bloggerIdFilter: bloggerId, beforeAddedAtFilter: nil) { postFavoriteList, hasMoreFavorite in
                var postIds: [String] = []
                for postFavorite in postFavoriteList {
                    postIds.append(postFavorite.post)
                }
                if postIds.count > 0 {
                    self.postAggregateService.getListByIds(postIds: postIds, currentBloggerId: bloggerId) { posts, hasMore in
                        self.couldGetNextPage = hasMoreFavorite
                        self.postListTableViewDataSource.clearPosts()
                        self.postListTableViewDataSource.addPosts(posts)
                        self.feedView?.postsTableView.reloadData()
                        self.refreshControl.endRefreshing()
                        self.refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Pull to refresh"))
                        self.spinnerView.hide()
                    }
                } else {
                    self.postListTableViewDataSource.clearPosts()
                    self.feedView?.postsTableView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Pull to refresh"))
                    self.spinnerView.hide()
                }
            }
        }
    }
}

/** @todo move to the common place */
extension FavoritesViewController: UITableViewDelegate {
    func selectedCell(row: Int) {
        let post = self.postListTableViewDataSource.posts[row]
        favoritesCoordinator.openPost(post: post)
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
                var beforeAddedAtFilter: Date? = nil
                if let lastPost = postListTableViewDataSource.posts.last {
                    beforeAddedAtFilter = lastPost.favorite?.addedAt
                }
                if let bloggerId = self.blogger?.id {
                    self.spinnerView.show()
                    self.postFavoritesDataProvider.getListByBlogger(limit: paginationLimit, bloggerIdFilter: bloggerId, beforeAddedAtFilter: beforeAddedAtFilter) { postFavoriteList, hasMoreFavorite in
                        var postIds: [String] = []
                        for postFavorite in postFavoriteList {
                            postIds.append(postFavorite.post)
                        }
                        self.postAggregateService.getListByIds(postIds: postIds, currentBloggerId: bloggerId) { posts, hasMore in
                            self.couldGetNextPage = hasMoreFavorite
                            self.postListTableViewDataSource.addPosts(posts)
                            self.feedView?.postsTableView.reloadData()
                            self.spinnerView.hide()
                        }
                    }
                }
            }
        }
    }
}
