import UIKit

class PostAggregateViewController: UIViewController {
    let postCommentDataProvider: PostCommentDataProviderProtocol
    let postCommentStorage: PostCommentStorageProtocol
    let postCommentsTableViewDataSource: PostCommentsTableViewDataSource = PostCommentsTableViewDataSource()
    let postTitle: String
    let post: PostAggregate
    let postCommentsTableView: UITableView = {
        let postCommentsTableView = UITableView.init(frame: .zero, style: .grouped)
        postCommentsTableView.translatesAutoresizingMaskIntoConstraints = false
        return postCommentsTableView
    }()
    
//    var newCommentTextInput: CustomTextInputWithLabel = {
//        let textInput = CustomTextInputWithLabel()
//        textInput.placeholder = String(localized: "Awesome comment")
//        textInput.label.text = String(localized: "Add comment")
//        
//        return textInput
//    }()
//    var addPostCommentButton: CustomButton = {
//        let button = CustomButton(
//            title: String(localized: "Add comment"),
//            titleColor: UiKitFacade.shared.getPrimaryTextColor(),
//            titleFor: .normal,
//            buttonTappedCallback: nil
//        )
//        button.layer.cornerRadius = 4
//        button.backgroundColor = UiKitFacade.shared.getAccentColor()
//        button.layer.shadowOpacity = 0.7
//        button.layer.shadowOffset = CGSize(width: 4, height: 4)
//        button.layer.shadowColor = UiKitFacade.shared.getAccentColor().cgColor
//        button.layer.shadowRadius = CGFloat(4)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        
//        return button
//    }()
    
    public init(post: PostAggregate) {
        self.postCommentDataProvider = FirestorePostCommentDataProvider()
        self.postCommentStorage = FirestorePostCommentStorage()
        self.postTitle = "Post \(post.post.content.count)"
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            postCommentsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            postCommentsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            postCommentsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postCommentsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = postTitle
        view.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        
        view.addSubview(postCommentsTableView)
        
        postCommentsTableView.dataSource = postCommentsTableViewDataSource
        postCommentsTableView.delegate = self
        postCommentsTableView.rowHeight = UITableView.automaticDimension
        postCommentsTableView.register(PostCommentTableViewCell.self, forCellReuseIdentifier: postCommentsTableViewDataSource.forCellReuseIdentifier)
        postCommentsTableView.sectionHeaderHeight = UITableView.automaticDimension
        postCommentsTableView.sectionFooterHeight = UITableView.automaticDimension
        activateConstraints()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
//        view.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
//        view.addSubview(newCommentTextInput)
//        view.addSubview(addPostCommentButton)
//        NSLayoutConstraint.activate([
//            newCommentTextInput.topAnchor.constraint(equalTo: postCommentsTableView.bottomAnchor, constant: 8),
//            newCommentTextInput.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
//            newCommentTextInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
//            newCommentTextInput.heightAnchor.constraint(equalToConstant: 40),
//            addPostCommentButton.topAnchor.constraint(equalTo: newCommentTextInput.bottomAnchor, constant: 8),
//            addPostCommentButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
//            addPostCommentButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
//            addPostCommentButton.heightAnchor.constraint(equalToConstant: 40)
//        ])
//        postCommentDataProvider.getList(limit: 10, postIdFilter: post.post.id!, parentIdFilter: nil) { postComments, hasMore in
//            for postComment in postComments {
//            }
//        }
//        addPostCommentButton.setButtonTappedCallback({sender in
//            if let content = self.newCommentTextInput.text {
//                if let postId = self.post.post.id {
//                    let postComment = PostComment(
//                        blogger: self.post.blogger.userId,
//                        post: postId,
//                        comment: content,
//                        commentedAt: Date()
//                    )
//                    self.postCommentStorage.add(postComment: postComment) { postComment in
//                        print(postComment)
//                        self.newCommentTextInput.text = ""
//                    }
//                }
//            }
//        })
    }
}

extension PostAggregateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return PostAggregateTableHeaderViewBuilder.build(self.post)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return PostAggregateTableHeaderViewBuilder.headerHeight
    }
}
