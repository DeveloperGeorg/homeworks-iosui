import UIKit
import iOSIntPackage

class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    private let profileCoordinator: ProfileCoordinator
    enum ValidationError: Error {
            case notFound
        }
    private let bloggerDataProvider: BloggerDataProviderProtocol
    fileprivate let forCellReuseIdentifier = "test"
    private var userService: UserService
    private var updatingImagesCounter = 0
    private let updatingImagesMaxCounter = 4
    var user: User
    var blogger: BloggerPreview? = nil
    var posts: [PostAggregate] = []
    var postListTableViewDataSource = PostListTableViewDataSource()
    let postAggregateService: PostAggregateServiceProtocol
    let paginationLimit = 10
    var couldGetNextPage = true
    
    fileprivate let postsFilters: [ColorFilter] = [
        .sepia(intensity: 0.5),
        .monochrome(color: CIColor.init(red: 0/255, green: 0/255, blue: 0/255),
                    intensity: 0.8),
        .noir,
        .posterize,
        .bloom(intensity: 0.7)
    ]
    
    let refreshControl = UIRefreshControl()
    let postsTableView: UITableView = {
        let postsTableView = UITableView.init(frame: .zero, style: .plain)
        postsTableView.translatesAutoresizingMaskIntoConstraints = false
        return postsTableView
    }()
    

    init(userService: UserService, profileCoordinator: ProfileCoordinator) throws {
        self.userService = userService
        self.profileCoordinator = profileCoordinator
        self.postListTableViewDataSource.setPostLikeDataStorage(FirestorePostLikeDataStorage())
        self.postListTableViewDataSource.setPostFavoritesDataStorage(FirestorePostFavoritesDataStorage())
        if let user = self.userService.getUserIfAuthorized() {
            self.user = user
            self.postAggregateService = FirestorePostAggregateService()
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
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            postsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            postsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        
        view.addSubview(postsTableView)
        
        refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Pull to refresh"))
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        postsTableView.addSubview(refreshControl)
        
        postsTableView.dataSource = postListTableViewDataSource
        postsTableView.delegate = self
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.register(PostItemTableViewCell.self, forCellReuseIdentifier: postListTableViewDataSource.forCellReuseIdentifier)
        
        activateConstraints()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        print(self.user.userId)
        bloggerDataProvider.getByUserId(self.user.userId) { blogger in
            if let blogger = blogger {
                self.blogger = blogger
                self.postListTableViewDataSource.setCurrentBloggerId(blogger.id)
                self.profileCoordinator.setBlogger(blogger)
                self.postAggregateService.getList(limit: self.paginationLimit, beforePostedAtFilter: nil, bloggerIdFilter: blogger.id, currentBloggerId: self.blogger?.id) { posts, hasMore in
                    self.couldGetNextPage = hasMore
                    self.postListTableViewDataSource.addPosts(posts)
                    self.postsTableView.reloadData()
                }
            }
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Start refreshing"))
        if let blogger = self.blogger {
            self.postAggregateService.getList(limit: self.paginationLimit, beforePostedAtFilter: nil, bloggerIdFilter: blogger.id, currentBloggerId: self.blogger?.id) { posts, hasMore in
                self.couldGetNextPage = hasMore
                self.postListTableViewDataSource.clearPosts()
                self.postListTableViewDataSource.addPosts(posts)
                self.postsTableView.reloadData()
                self.refreshControl.endRefreshing()
                self.refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Pull to refresh"))
            }
        } else {
            bloggerDataProvider.getByUserId(self.user.userId) { blogger in
                if let blogger = blogger {
                    self.blogger = blogger
                    self.profileCoordinator.setBlogger(blogger)
                    self.postAggregateService.getList(limit: self.paginationLimit, beforePostedAtFilter: nil, bloggerIdFilter: blogger.id, currentBloggerId: self.blogger?.id) { posts, hasMore in
                        self.couldGetNextPage = hasMore
                        self.postListTableViewDataSource.addPosts(posts)
                        self.postsTableView.reloadData()
                        self.refreshControl.endRefreshing()
                        self.refreshControl.attributedTitle = NSAttributedString(string: String(localized: "Pull to refresh"))
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ProfileTableHederView.init(profile: self.blogger, frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 290), profileCoordinator: self.profileCoordinator)
            
            return headerView
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 290
        }
}

extension ProfileViewController: UITableViewDelegate {
    func selectedCell(row: Int) {
        /** @todo create and use posts coordinator */
        let post = self.postListTableViewDataSource.posts[row]
        self.profileCoordinator.openPost(post: post)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
