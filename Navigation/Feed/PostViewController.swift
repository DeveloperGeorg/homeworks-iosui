import UIKit

class PostViewController: UIViewController {
    let postTitle: String
    weak var coordinator: FeedCoordinator?
    
    public init(postTitle: String, coordinator: FeedCoordinator?) {
        self.postTitle = postTitle
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        let infoButtonItem = UIBarButtonItem(
            title: "Info",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(showInfoModal)
        )
        navigationItem.rightBarButtonItem = infoButtonItem
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = postTitle
        view.backgroundColor = .white
    }
    
    @objc private func showInfoModal() {
        coordinator?.showInfo()
    }
}
