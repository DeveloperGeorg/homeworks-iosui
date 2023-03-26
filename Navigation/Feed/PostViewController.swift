import UIKit

class PostViewController: UIViewController {
    let postCommentDataProvider: PostCommentDataProviderProtocol
    let postTitle: String
    let post: PostAggregate
    weak var coordinator: FeedCoordinator?
    var tempPostContent: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    public init(post: PostAggregate, coordinator: FeedCoordinator?) {
        self.postCommentDataProvider = FirestorePostCommentDataProvider()
        self.postTitle = "Post \(post.post.content.count)"
        self.post = post
        var text = "Blogger: \(post.blogger.name) (#\(String(describing: post.blogger.id))\n"
        text += "Description: \(post.blogger.shortDescription)\n"
        text += "Image: \(post.blogger.imageLink)\n"
        text += "Post content: \(post.post.content)\n"
        text += "Likes amount: \(post.post.likesAmount)\n"
        text += "Comments amount: \(post.post.commentsAmount)\n"
        tempPostContent.text = text
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
        view.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        tempPostContent.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        view.addSubview(tempPostContent)
        NSLayoutConstraint.activate([
            tempPostContent.widthAnchor.constraint(equalTo: view.widthAnchor),
            tempPostContent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tempPostContent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tempPostContent.topAnchor.constraint(equalTo: view.topAnchor),
            tempPostContent.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        postCommentDataProvider.getList(limit: 10, postIdFilter: post.post.id!, parentIdFilter: nil) { postComments, hasMore in
            self.tempPostContent.text += "-----------------\n"
            self.tempPostContent.text += "Comments:\n"
            for postComment in postComments {
                self.tempPostContent.text += "---\n"
                self.tempPostContent.text += "Blogger ID: \(postComment.blogger)\n"
                self.tempPostContent.text += "Parent: \(String(describing: postComment.parent))\n"
                self.tempPostContent.text += "commentedAt: \(postComment.commentedAt)\n"
                self.tempPostContent.text += "Comment: \(postComment.comment)\n"
            }
        }
    }
    
    @objc private func showInfoModal() {
        coordinator?.showInfo()
    }
}
