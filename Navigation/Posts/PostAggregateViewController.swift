import UIKit

class PostAggregateViewController: UIViewController {
    let postCommentDataProvider: PostCommentDataProviderProtocol
    let postCommentStorage: PostCommentStorageProtocol
    let postCommentsTableViewDataSource: PostCommentsTableViewDataSource = PostCommentsTableViewDataSource()
    let postLikeDataStorage: PostLikeDataStorageProtocol = FirestorePostLikeDataStorage()
    let postFavoritesDataStorage: PostFavoritesDataStorageProtocol = FirestorePostFavoritesDataStorage()
    let bloggerDataProvider: BloggerDataProviderProtocol = FirestoreBloggerDataProvider()
    let postAggregateService: PostAggregateServiceProtocol = FirestorePostAggregateService()
    let postTitle: String
    let post: PostAggregate
    var currentBlogger: BloggerPreview?
    var currentBloggerId: String?
    let commentsPaginationLimit = 3
    var couldGetNextPage = true
    let postCommentsTableView: UITableView = {
        let postCommentsTableView = UITableView.init(frame: .zero, style: .grouped)
        postCommentsTableView.translatesAutoresizingMaskIntoConstraints = false
        return postCommentsTableView
    }()
    
    var newCommentTextInput: CustomTextInput = {
        let textInput = CustomTextInput()
        textInput.placeholder = String(localized: "Add comment")
        
        return textInput
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
    
    public init(post: PostAggregate, userService: UserService) {
        self.postCommentDataProvider = FirestorePostCommentDataProvider()
        self.postCommentStorage = FirestorePostCommentStorage()
        self.postTitle = "Post \(post.post.content.count)"
        self.post = post
        super.init(nibName: nil, bundle: nil)
        if let user = userService.getUserIfAuthorized() {
            self.bloggerDataProvider.getByUserId(user.userId) { blogger in
                if let blogger = blogger {
                    self.currentBlogger = blogger
                    self.currentBloggerId = blogger.id
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            postCommentsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            postCommentsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            postCommentsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            postCommentsTableView.bottomAnchor.constraint(equalTo: newCommentTextInput.topAnchor, constant: -8),
            newCommentTextInput.topAnchor.constraint(equalTo: postCommentsTableView.bottomAnchor, constant: 8),
            newCommentTextInput.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            newCommentTextInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            newCommentTextInput.heightAnchor.constraint(equalToConstant: 40),
            addPostCommentButton.topAnchor.constraint(equalTo: newCommentTextInput.bottomAnchor, constant: 8),
            addPostCommentButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            addPostCommentButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            addPostCommentButton.heightAnchor.constraint(equalToConstant: 40),
            addPostCommentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = postTitle
        view.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        
        view.addSubviews([
            postCommentsTableView,
            newCommentTextInput,
            addPostCommentButton
        ])
        
        postCommentsTableView.dataSource = postCommentsTableViewDataSource
        postCommentsTableView.delegate = self
        postCommentsTableView.rowHeight = UITableView.automaticDimension
        postCommentsTableView.register(PostCommentTableViewCell.self, forCellReuseIdentifier: postCommentsTableViewDataSource.forCellReuseIdentifier)
        postCommentsTableView.sectionHeaderHeight = UITableView.automaticDimension
        postCommentsTableView.sectionFooterHeight = UITableView.automaticDimension
        
        postAggregateService.getPostCommentAggregateList(limit: commentsPaginationLimit, postIdFilter: post.post.id!, parentIdFilter: nil, afterCommentedAtFilter: nil) { postComments, hasMore in
            self.postCommentsTableViewDataSource.addPostComments(postComments)
            self.couldGetNextPage = hasMore
            self.postCommentsTableView.reloadData()
        }
        
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
        addPostCommentButton.setButtonTappedCallback({sender in
            if let content = self.newCommentTextInput.text {
                if let blogger = self.currentBlogger {
                    if let currentBloggerId = blogger.id {
                        if let postId = self.post.post.id {
                            let postComment = PostComment(
                                blogger: currentBloggerId,
                                post: postId,
                                comment: content,
                                commentedAt: Date()
                            )
                            self.postCommentStorage.add(postComment: postComment) { postComment in
                                print(postComment)
                                self.newCommentTextInput.text = ""
                                if !self.couldGetNextPage {
                                    self.postCommentsTableViewDataSource.addPostComments([
                                        PostCommentAggregate(postComment: postComment, blogger: blogger)
                                    ])
                                }
                                self.postCommentsTableView.reloadData()
                            }
                        }
                    }
                }
            }
        })
    }
    @objc func likeTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if let currentBloggerId = currentBloggerId {
                if !post.isLiked {
                    if let postId = post.post.id {
                        postAggregateService.likePost(bloggerId: currentBloggerId, postId: postId) { postLike in
                            if let postLike = postLike {
                                print("success like")
                                print(postLike)
                                self.post.isLiked = true
                                self.post.likesAmount += 1
                                self.post.like = postLike
                            } else {
                                print("post was not liked")
                            }
                        }
                    } else {
                        print("no post id was got \(self.post.post.id)")
                    }
                } else {
                    print("Post has been liked already. Trying to remove")
                    if let postLike = post.like {
                        postLikeDataStorage.remove(postLike) { wasRemoved in
                            print("Remove result \(wasRemoved)")
                        }
                        post.isLiked = false
                        post.likesAmount -= 1
                        post.like = nil
                        /** @todo set postLike nil */
                    }
                }
            }
        }
    }
    @objc func favoriteTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if let currentBloggerId = currentBloggerId {
                if let index = sender.view?.tag {
                    if !post.isFavorite {
                        if let postId = post.post.id {
                            postAggregateService.favoritePost(bloggerId: currentBloggerId, postId: postId) { postFavorites in
                                if let postFavorites = postFavorites {
                                    print("success favorite")
                                    print(postFavorites)
                                    self.post.isFavorite = true
                                    self.post.favorite = postFavorites
                                } else {
                                    print("post was not added in favorite")
                                }
                            }
                        } else {
                            print("no post id was got \(self.post.post.id)")
                        }
                    } else {
                        print("Post has been added in favorite already. Trying to remove")
                        if let postFavorite = self.post.favorite {
                            print(postFavorite)
                            postFavoritesDataStorage.remove(postFavorite) { wasRemoved in
                                print("Remove result \(wasRemoved)")
                                self.post.isFavorite = false
                                self.post.favorite = nil
                            }
                        }
                    }
                } else {
                    print("no index was got \(sender.view?.tag)")
                }
            } else {
                print("no current blogger was set \(currentBloggerId)")
            }
            
        }
    }
}

extension PostAggregateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return PostAggregateTableHeaderViewBuilder.build(
            self.post,
            likeTapGesture: UITapGestureRecognizer(target: self, action: #selector(likeTap)),
            favoriteTapGesture: UITapGestureRecognizer(target: self, action: #selector(favoriteTap))
        )
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return PostAggregateTableHeaderViewBuilder.headerHeight
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let vw = UIView()
//        vw.backgroundColor = UIColor.clear
//        let titleLabel = UILabel(frame: CGRect(x:10,y: 5 ,width:350,height:150))
//        titleLabel.numberOfLines = 0;
//        titleLabel.lineBreakMode = .byWordWrapping
//        titleLabel.backgroundColor = UIColor.clear
//        titleLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
//        titleLabel.text  = "Footer text here"
//        vw.addSubview(titleLabel)
//        return vw
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 150
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = Int(indexPath.row)
        if postCommentsTableViewDataSource.postComments.endIndex-1 == index {
            if self.couldGetNextPage {
                print("load new data..")
                var afterCommentedAtFilter: Date? = nil
                if let lastComment = postCommentsTableViewDataSource.postComments.last {
                    afterCommentedAtFilter = lastComment.postComment.commentedAt
                }
                
                postAggregateService.getPostCommentAggregateList(limit: commentsPaginationLimit, postIdFilter: post.post.id!, parentIdFilter: nil, afterCommentedAtFilter: afterCommentedAtFilter) { postComments, hasMore in
                    print(postComments)
                    print("hasMore \(hasMore)")
                    self.postCommentsTableViewDataSource.addPostComments(postComments)
                    self.couldGetNextPage = hasMore
                    self.postCommentsTableView.reloadData()
                }
            }
        }
    }
}
