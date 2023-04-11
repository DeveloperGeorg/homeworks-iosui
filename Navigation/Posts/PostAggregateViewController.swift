import UIKit

class PostAggregateViewController: UIViewController {
    let postCommentDataProvider: PostCommentDataProviderProtocol
    let postCommentStorage: PostCommentStorageProtocol
    let postTitle: String
    let post: PostAggregate
    var tempPostContent: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    var addPostCommentButton: CustomButton = {
        let button = CustomButton(
            title: String(localized: "Add comment"),
            titleColor: UiKitFacade.shared.getPrimaryTextColor(),
            titleFor: .normal,
            buttonTappedCallback: nil
        )
        button.layer.cornerRadius = 4
        button.backgroundColor = UiKitFacade.shared.getAccentColor()
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = UiKitFacade.shared.getAccentColor().cgColor
        button.layer.shadowRadius = CGFloat(4)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    public init(post: PostAggregate) {
        self.postCommentDataProvider = FirestorePostCommentDataProvider()
        self.postCommentStorage = FirestorePostCommentStorage()
        self.postTitle = "Post \(post.post.content.count)"
        self.post = post
        var text = "Blogger: \(post.blogger.name) (#\(String(describing: post.blogger.id))\n"
        text += "Description: \(post.blogger.shortDescription)\n"
        text += "Image: \(post.blogger.imageLink)\n"
        text += "Post content: \(post.post.content)\n"
        text += "Likes amount: \(post.likesAmount)\n"
        text += "Comments amount: \(post.commentsAmount)\n"
        tempPostContent.text = text
        super.init(nibName: nil, bundle: nil)
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
        view.addSubview(addPostCommentButton)
        NSLayoutConstraint.activate([
            tempPostContent.widthAnchor.constraint(equalTo: view.widthAnchor),
            tempPostContent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tempPostContent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tempPostContent.topAnchor.constraint(equalTo: view.topAnchor),
            tempPostContent.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -160),
            addPostCommentButton.topAnchor.constraint(equalTo: tempPostContent.bottomAnchor, constant: 8),
            addPostCommentButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            addPostCommentButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            addPostCommentButton.heightAnchor.constraint(equalToConstant: 50)
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
        addPostCommentButton.setButtonTappedCallback({sender in
            let content = "Generated comment \(UUID().uuidString)"
            if let postId = self.post.post.id {
                let postComment = PostComment(
                    blogger: self.post.blogger.userId,
                    post: postId,
                    comment: content,
                    commentedAt: Date()
                )
                self.postCommentStorage.add(postComment: postComment) { postComment in
                    print(postComment)
                    self.tempPostContent.text += "---\n"
                    self.tempPostContent.text += "Blogger ID: \(postComment.blogger)\n"
                    self.tempPostContent.text += "Parent: \(String(describing: postComment.parent))\n"
                    self.tempPostContent.text += "commentedAt: \(postComment.commentedAt)\n"
                    self.tempPostContent.text += "Comment: \(postComment.comment)\n"
                }
            }
        })
    }
}
