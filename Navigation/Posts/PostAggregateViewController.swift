import UIKit

class PostAggregateViewController: UIViewController {
    let postCommentDataProvider: PostCommentDataProviderProtocol
    let postCommentStorage: PostCommentStorageProtocol
    let postCommentsTableViewDataSource: PostCommentsTableViewDataSource = PostCommentsTableViewDataSource()
    let postLikeDataStorage: PostLikeDataStorageProtocol = FirestorePostLikeDataStorage()
    let postFavoritesDataStorage: PostFavoritesDataStorageProtocol = FirestorePostFavoritesDataStorage()
    let bloggerDataProvider: BloggerDataProviderProtocol = FirestoreBloggerDataProvider()
    let postAggregateService: PostAggregateServiceProtocol = FirestorePostAggregateService()
    let post: PostAggregate
    var currentBlogger: BloggerPreview?
    var currentBloggerId: String?
    let commentsPaginationLimit = 5
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
            newCommentTextInput.topAnchor.constraint(equalTo: postCommentsTableView.bottomAnchor, constant: UiKitFacade.shared.getConstraintContant(1)),
            newCommentTextInput.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UiKitFacade.shared.getConstraintContant(1)),
            newCommentTextInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: UiKitFacade.shared.getConstraintContant(-1)),
            newCommentTextInput.heightAnchor.constraint(equalToConstant: UiKitFacade.shared.getConstraintContant(5)),
            addPostCommentButton.topAnchor.constraint(equalTo: newCommentTextInput.bottomAnchor, constant: UiKitFacade.shared.getConstraintContant(1)),
            addPostCommentButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UiKitFacade.shared.getConstraintContant(1)),
            addPostCommentButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            addPostCommentButton.heightAnchor.constraint(equalToConstant: UiKitFacade.shared.getConstraintContant(5)),
            addPostCommentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        postAggregateService.getPostCommentAggregateList(limit: commentsPaginationLimit, postIdFilter: post.post.id!, parentIdFilter: nil, beforeCommentedAtFilter: nil) { postComments, hasMore in
            self.postCommentsTableViewDataSource.addPostComments(postComments)
            self.couldGetNextPage = hasMore
            self.postCommentsTableView.reloadData()
        }
        
        activateConstraints()
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
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
                                self.newCommentTextInput.text = ""
                                self.postCommentsTableViewDataSource.addPostCommentInTheBeggining(PostCommentAggregate(postComment: postComment, blogger: blogger))
                                self.post.commentsAmount += 1
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
                                self.post.setLike(postLike)
                                self.updateTableHeader()
                            } else {
                                print("post was not liked")
                            }
                        }
                    } else {
                        print("no post id was got \(self.post.post.id)")
                    }
                } else {
                    if let postLike = post.like {
                        postLikeDataStorage.remove(postLike) { wasRemoved in
                            self.post.setLike(nil)
                            self.updateTableHeader()
                        }
                    }
                }
            }
        }
    }
    fileprivate func updateTableHeader() {
        self.postCommentsTableView.beginUpdates()
        self.postCommentsTableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: UITableView.RowAnimation.none)
        self.postCommentsTableView.endUpdates()
    }
    
    @objc func favoriteTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if let currentBloggerId = currentBloggerId {
                if let index = sender.view?.tag {
                    if !post.isFavorite {
                        if let postId = post.post.id {
                            postAggregateService.favoritePost(bloggerId: currentBloggerId, postId: postId) { postFavorites in
                                if let postFavorites = postFavorites {
                                    self.post.setFavorite(postFavorites)
                                    self.updateTableHeader()
                                } else {
                                    print("post was not added in favorite")
                                }
                            }
                        } else {
                            print("no post id was got \(self.post.post.id)")
                        }
                    } else {
                        if let postFavorite = self.post.favorite {
                            postFavoritesDataStorage.remove(postFavorite) { wasRemoved in
                                self.post.setFavorite(nil)
                                self.updateTableHeader()
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index = Int(indexPath.row)
        if postCommentsTableViewDataSource.postComments.endIndex-1 == index {
            if self.couldGetNextPage {
                var beforeCommentedAtFilter: Date? = nil
                if let lastComment = postCommentsTableViewDataSource.postComments.last {
                    beforeCommentedAtFilter = lastComment.postComment.commentedAt
                }
                
                postAggregateService.getPostCommentAggregateList(limit: commentsPaginationLimit, postIdFilter: post.post.id!, parentIdFilter: nil, beforeCommentedAtFilter: beforeCommentedAtFilter) { postComments, hasMore in
                    self.postCommentsTableViewDataSource.addPostComments(postComments)
                    self.couldGetNextPage = hasMore
                    self.postCommentsTableView.reloadData()
                }
            }
        }
    }
}
