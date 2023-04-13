import UIKit

class FavoritesViewController: UIViewController {
    var favoritesCoordinator: FavoritesCoordinator
    var feedView: FeedView?
    var postListTableViewDataSource = PostListTableViewDataSource()
    let postDataProviderProtocol: PostAggregateDataProviderProtocol
    let postLikeDataProvider: PostLikeDataProviderProtocol
    let postCommentDataProvider: PostCommentDataProviderProtocol
    let postFavoritesDataProvider: PostFavoritesDataProviderProtocol
    let paginationLimit = 5;
    var couldGetNextPage = true
    let refreshControl = UIRefreshControl()
    
    let temporaryBloggerId = "5WSoAxbM6IVfobdPRpAU3PpA0wO2"
    
    public init(favoritesCoordinator: FavoritesCoordinator) {
        self.favoritesCoordinator = favoritesCoordinator
        self.postDataProviderProtocol = FirestorePostAggregateDataProvider()
        self.postLikeDataProvider = FirestorePostLikeDataProvider()
        self.postCommentDataProvider = FirestorePostCommentDataProvider()
        self.postFavoritesDataProvider = FirestorePostFavoritesDataProvider()
        self.postListTableViewDataSource.setCurrentBloggerId(self.temporaryBloggerId)
        self.postListTableViewDataSource.setPostLikeDataStorage(FirestorePostLikeDataStorage())
        self.postListTableViewDataSource.setPostFavoritesDataStorage(FirestorePostFavoritesDataStorage())
        super.init(nibName: nil, bundle: nil)
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
        self.postFavoritesDataProvider.getListByBlogger(limit: paginationLimit, bloggerIdFilter: temporaryBloggerId, beforeAddedAtFilter: nil) { postFavoriteList, hasMoreFavorite in
            var postIds: [String] = []
            for postFavorite in postFavoriteList {
                postIds.append(postFavorite.post)
            }
            self.postDataProviderProtocol.getListByIds(postIds: postIds, currentBloggerId: self.temporaryBloggerId) { posts, hasMore in
                self.couldGetNextPage = hasMoreFavorite
                self.postListTableViewDataSource.addPosts(posts)
                self.feedView?.postsTableView.reloadData()
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
        self.postFavoritesDataProvider.getListByBlogger(limit: paginationLimit, bloggerIdFilter: temporaryBloggerId, beforeAddedAtFilter: nil) { postFavoriteList, hasMoreFavorite in
            var postIds: [String] = []
            for postFavorite in postFavoriteList {
                postIds.append(postFavorite.post)
            }
            self.postDataProviderProtocol.getListByIds(postIds: postIds, currentBloggerId: self.temporaryBloggerId) { posts, hasMore in
                self.couldGetNextPage = hasMoreFavorite
                self.postListTableViewDataSource.clearPosts()
                self.postListTableViewDataSource.addPosts(posts)
                self.feedView?.postsTableView.reloadData()
                self.refreshControl.endRefreshing()
                self.refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Pull to refresh"))
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
                self.postFavoritesDataProvider.getListByBlogger(limit: paginationLimit, bloggerIdFilter: temporaryBloggerId, beforeAddedAtFilter: beforeAddedAtFilter) { postFavoriteList, hasMoreFavorite in
                    var postIds: [String] = []
                    for postFavorite in postFavoriteList {
                        postIds.append(postFavorite.post)
                    }
                    self.postDataProviderProtocol.getListByIds(postIds: postIds, currentBloggerId: self.temporaryBloggerId) { posts, hasMore in
                        self.couldGetNextPage = hasMoreFavorite
                        self.postListTableViewDataSource.addPosts(posts)
                        self.feedView?.postsTableView.reloadData()
                    }
                }
            }
        }
    }
}
