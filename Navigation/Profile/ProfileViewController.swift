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
    var posts: [PostAggregate] = []
    var postListTableViewDataSource = PostListTableViewDataSource()
    let postDataProviderProtocol: PostAggregateDataProviderProtocol
    let paginationLimit = 10
    var couldGetNextPage = true
    let tempUserId = "WQpoef1OsQSZALcfZy97puNV9QV2"
    
    fileprivate let postsFilters: [ColorFilter] = [
        .sepia(intensity: 0.5),
        .monochrome(color: CIColor.init(red: 0/255, green: 0/255, blue: 0/255),
                    intensity: 0.8),
        .noir,
        .posterize,
        .bloom(intensity: 0.7)
    ]
    
    let postsTableView: UITableView = {
        let postsTableView = UITableView.init(frame: .zero, style: .plain)
        postsTableView.translatesAutoresizingMaskIntoConstraints = false
        return postsTableView
    }()
    

    init(userService: UserService, fullName: String, profileCoordinator: ProfileCoordinator) {
        self.userService = userService
        self.profileCoordinator = profileCoordinator
        /* @todo check password */
        if let user = self.userService.getUserByFullName(fullName) {
            self.user = user
        } else {
            self.user = User(
            fullName: fullName, avatarImageSrc: "cat-avatar.png", status: String(localized: "some state"))
        }
        self.postDataProviderProtocol = FirestorePostAggregateDataProvider()
        self.bloggerDataProvider = FirestoreBloggerDataProvider()
        
        super.init(nibName: nil, bundle: nil)
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
        #if DEBUG
        view.backgroundColor = UIColor.createColor(lightMode: .systemPurple, darkMode: .systemCyan)
        #endif
        
        view.addSubview(postsTableView)
        
        postsTableView.dataSource = postListTableViewDataSource
        postsTableView.delegate = self
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.register(PostItemTableViewCell.self, forCellReuseIdentifier: postListTableViewDataSource.forCellReuseIdentifier)
        
        activateConstraints()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        bloggerDataProvider.getByUserId(tempUserId) { blogger in
            if let blogger = blogger {
                self.postDataProviderProtocol.getList(limit: self.paginationLimit, beforePostedAtFilter: nil, bloggerIdFilter: blogger.id) { posts, hasMore in
                    self.couldGetNextPage = hasMore
                    self.postListTableViewDataSource.addPosts(posts)
                    self.postsTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ProfileTableHederView.init(profile: self.user, frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 290), profileCoordinator: self.profileCoordinator)
            
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
