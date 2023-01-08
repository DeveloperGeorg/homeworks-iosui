import UIKit
import iOSIntPackage
import StorageService

class ProfileViewController: UIViewController {
    enum ValidationError: Error {
            case notFound
        }

    fileprivate let forCellReuseIdentifier = "test"
    private var userService: UserService
    private var imagePublisherFacade: ImagePublisherFacade
    private var updatingImagesCounter = 0
    private let updatingImagesMaxCounter = 4
    var user: User
    var posts: [Post] = [
        {
            return Post(author: "Test1", description: "Amaizing description 1", image: UIImage(named: "post1.jpg")!, likes: 10, views: 25)
        }(),
        {
            return Post(
                author: "Test2. Changing you mind. You will never forget! I'll promise. This is extraordinarily long author name",
                description: "Amaizing description 2. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                image: UIImage(named: "post2.jpg")!,
                likes: 201,
                views: 235
            )
        }(),
        {
            return Post(author: "Test3", description: "Amaizing description 3", image: UIImage(named: "post3.jpg")!, likes: 30, views: 75)
        }(),
        {
            return Post(author: "Test1", description: "Amaizing description 4", image: UIImage(named: "post1.jpg")!, likes: 25, views: 59)
        }(),
        {
            return Post(author: "Test2", description: "Amaizing description 5", image: UIImage(named: "post1.jpg")!, likes: 35, views: 338)
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
    

    init(userService: UserService, fullName: String) throws {
        self.userService = userService
        /* @todo check password */
        if let user = self.userService.getUserByFullName(fullName) {
            self.user = user
        } else {
            self.user = User(
            fullName: fullName, avatarImageSrc: "cat-avatar.png", status: "some state")
        }
        self.imagePublisherFacade = ImagePublisherFacade()
        
        super.init(nibName: nil, bundle: nil)
        
        self.imagePublisherFacade.subscribe(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
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
        view.backgroundColor = .systemGray
        #if DEBUG
        view.backgroundColor = .systemPurple
        #endif
        
        view.addSubview(postsTableView)
        
        postsTableView.dataSource = self
        postsTableView.delegate = self
        postsTableView.rowHeight = UITableView.automaticDimension
        
        postsTableView.register(PostTableViewCell.self, forCellReuseIdentifier: forCellReuseIdentifier)
        
        activateConstraints()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        imagePublisherFacade.addImagesWithTimer(time: 5, repeat: 20)
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
        
        let index = Int(indexPath.row)
        let post = self.posts[index] as Post
        cell.titleView.text = post.author
        let image = post.image
        let filterUserInitiated = postsFilters.indices.contains(index) ? postsFilters[index] : .chrome
        let start = DispatchTime.now()
        imageProcessor.processImagesOnThread(
            sourceImages: [image],
            filter: filterUserInitiated,
            qos: QualityOfService.userInitiated,
            completion: {(imagesWithFilter) -> Void in
                guard let cgImage = imagesWithFilter.first! else {
                    return
                }
                DispatchQueue.main.async {
                    cell.postImageView.image = UIImage(cgImage: cgImage)
                }
                let end = DispatchTime.now()
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let timeInterval = Double(nanoTime) / 1_000_000_000
                print("initiated filter has been executed in \(timeInterval) seconds")
        })
        imageProcessor.processImagesOnThread(
            sourceImages: [image],
            filter: .colorInvert,
            qos: QualityOfService.userInteractive,
            completion: {(imagesWithFilter) -> Void in
                guard let cgImage = imagesWithFilter.first! else {
                    return
                }
                DispatchQueue.main.async {
                    cell.postImageView.image = UIImage(cgImage: cgImage)
                }
                let end = DispatchTime.now()
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let timeInterval = Double(nanoTime) / 1_000_000_000
                print("interactive filter has been executed in \(timeInterval) seconds")
        })
        imageProcessor.processImagesOnThread(
            sourceImages: [image],
            filter: .noir,
            qos: QualityOfService.utility,
            completion: {(imagesWithFilter) -> Void in
                guard let cgImage = imagesWithFilter.first! else {
                    return
                }
                DispatchQueue.main.async {
                    cell.postImageView.image = UIImage(cgImage: cgImage)
                }
                let end = DispatchTime.now()
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let timeInterval = Double(nanoTime) / 1_000_000_000
                print("utility filter has been executed in \(timeInterval) seconds")
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

extension ProfileViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        updatingImagesCounter += 1
        print("Image was received. Counter \(updatingImagesCounter)")
        if updatingImagesCounter == updatingImagesMaxCounter {
            imagePublisherFacade.removeSubscription(for: self)
        }
        for image in images {
            let index = Int(arc4random_uniform(UInt32(posts.count)))
            posts[index].image = image
        }
        self.postsTableView.reloadData()
    }
}
