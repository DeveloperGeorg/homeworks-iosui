import UIKit

class ProfileViewController: UIViewController {
    enum ValidationError: Error {
            case notFound
        }

    fileprivate let forCellReuseIdentifier = "test"
    private var userService: UserService
    var user: User
    let posts: [Post] = [
        {
            return Post(author: "Test1", description: "Amaizing description 1", image: "post1.jpg", likes: 10, views: 25)
        }(),
        {
            return Post(
                author: "Test2. Changing you mind. You will never forget! I'll promise. This is extraordinarily long author name",
                description: "Amaizing description 2. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                image: "post2.jpg",
                likes: 201,
                views: 235
            )
        }(),
        {
            return Post(author: "Test3", description: "Amaizing description 3", image: "post3.jpg", likes: 30, views: 75)
        }(),
        {
            return Post(author: "Test1", description: "Amaizing description 4", image: "post1.jpg", likes: 25, views: 59)
        }(),
        {
            return Post(author: "Test2", description: "Amaizing description 5", image: "post1.jpg", likes: 35, views: 338)
        }(),
    ]
    
    let postsTableView: UITableView = {
        let postsTableView = UITableView.init(frame: .zero, style: .plain)
        postsTableView.translatesAutoresizingMaskIntoConstraints = false
        return postsTableView
    }()
    
    init(userService: UserService, fullName: String) throws {
        self.userService = userService
        if let user = self.userService.getUserByFullName(fullName) {
            self.user = user
        } else {
            throw ValidationError.notFound
        }
        
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
        
        view.addSubview(postsTableView)
        
        postsTableView.dataSource = self
        postsTableView.delegate = self
        postsTableView.rowHeight = UITableView.automaticDimension
        
        postsTableView.register(PostTableViewCell.self, forCellReuseIdentifier: forCellReuseIdentifier)
        
        activateConstraints()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ProfileTableHederView.init(profile: self.user, frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 250))
            
            return headerView
        }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 250
        }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: forCellReuseIdentifier, for: indexPath) as! PostTableViewCell
        
        let post = self.posts[indexPath.row] as Post
        cell.titleView.text = post.author
        let image = UIImage(named: post.image)
        cell.postImageView.image = image
        cell.likesCounterView.text = "Likes: \(post.likes)"
        cell.viewsCounterView.text = "Views: \(post.views)"
        cell.descriptionView.text = post.description
        
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    func selectedCell(row: Int) {
        let viewControllerNext = UIViewController()
        viewControllerNext.view.backgroundColor = .systemRed
        viewControllerNext.title = "\(posts[row].author)".uppercased()
        
        navigationController?.pushViewController(viewControllerNext, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
