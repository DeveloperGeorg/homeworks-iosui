import UIKit
import iOSIntPackage

class ProfileViewController: UIViewController {
    fileprivate let forCellReuseIdentifier = "test"
    var profile: Profile = {
        return Profile(name: "Hipster cat", imageSrc: "cat-avatar.png", state: "some state")
    }()
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
    
    let imageProcessor: ImageProcessor = ImageProcessor()
    
    
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
            let headerView = ProfileTableHederView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 250))
            
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
        
        let index = Int(indexPath.row)
        let post = self.posts[index] as Post
        cell.titleView.text = post.author
        var image = UIImage(named: post.image)
        let filter = postsFilters.indices.contains(index) ? postsFilters[index] : .chrome
        imageProcessor.processImage(sourceImage: image!, filter: filter, completion: {(imageWithFilter) -> Void in
            image = imageWithFilter
        })
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
