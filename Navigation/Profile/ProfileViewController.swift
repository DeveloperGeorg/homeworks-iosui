import UIKit
import iOSIntPackage

class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    enum ValidationError: Error {
            case notFound
        }

    fileprivate let forCellReuseIdentifier = "test"
    private var userService: UserService
    private var updatingImagesCounter = 0
    private let updatingImagesMaxCounter = 4
    var user: User
    var posts: [PostItem] = []
    var postListTableViewDataSource = PostListTableViewDataSource()
    let postDataProviderProtocol: PostDataProviderProtocol
    
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
    

    init(userService: UserService, fullName: String) {
        self.userService = userService
        /* @todo check password */
        if let user = self.userService.getUserByFullName(fullName) {
            self.user = user
        } else {
            self.user = User(
            fullName: fullName, avatarImageSrc: "cat-avatar.png", status: String(localized: "some state"))
        }
        self.postDataProviderProtocol = DebugPostDataProvider()
        
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
        postDataProviderProtocol.getList() { posts in
            self.postListTableViewDataSource.addPosts(posts)
            self.postsTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ProfileTableHederView.init(profile: self.user, frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 250))
            
            return headerView
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 250
        }
}

extension ProfileViewController: UITableViewDelegate {
    func selectedCell(row: Int) {
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
