import Foundation

protocol PostAggregateServiceProtocol {
    
    var bloggerDataProvider: BloggerDataProviderProtocol { get }
    var postDataProvider: PostDataProviderProtocol { get }
    var postItemDataStorage: PostItemDataStorageProtocol { get }
    var postLikeDataProvider: PostLikeDataProviderProtocol { get }
    var postLikeDataStorage: PostLikeDataStorageProtocol { get }
    var postCommentDataProvider: PostCommentDataProviderProtocol { get }
    var postCommentStorage: PostCommentStorageProtocol { get }
    var postFavoritesDataProvider: PostFavoritesDataProviderProtocol { get }
    var postFavoritesDataStorage: PostFavoritesDataStorageProtocol { get }
    
    func getList(
        limit: Int,
        beforePostedAtFilter: Date?,
        bloggerIdFilter: String?,
        currentBloggerId: String?,
        completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void
    )
    func getListByIds(
        postIds: [String],
        currentBloggerId: String?,
        completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void
    )
    func remove(_ postId: String, completionHandler: @escaping (Bool) -> Void)
    func getPostCommentAggregateList(limit: Int?, postIdFilter: String, parentIdFilter: String?, beforeCommentedAtFilter: Date?, completionHandler: @escaping ([PostCommentAggregate], Bool) -> Void)
    func likePost(bloggerId: String, postId: String, completionHandler: @escaping (PostLike?) -> Void)
    func favoritePost(bloggerId: String, postId: String, completionHandler: @escaping (PostFavorites?) -> Void)
}

extension PostAggregateServiceProtocol {
    func getList(
        limit: Int,
        beforePostedAtFilter: Date? = nil,
        bloggerIdFilter: String? = nil,
        currentBloggerId: String? = nil,
        completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void
    ) {
        self.postDataProvider.getList(limit: limit, beforePostedAtFilter: beforePostedAtFilter, bloggerIdFilter: bloggerIdFilter) { posts, hasMore in
            
            self.aggregatePosts(
                posts: posts,
                hasMore: hasMore,
                currentBloggerId: currentBloggerId,
                completionHandler: completionHandler
            )
        }
    }
    
    func getListByIds(
        postIds: [String],
        currentBloggerId: String? = nil,
        completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void
    ) {
        self.postDataProvider.getListByIds(postIds: postIds) { posts in
            self.aggregatePosts(
                posts: posts,
                hasMore: false,
                currentBloggerId: currentBloggerId,
                completionHandler: completionHandler
            )
        }
    }
    
    func remove(_ postId: String, completionHandler: @escaping (Bool) -> Void) {
        postItemDataStorage.remove(postId) { isPostRemoved in
            if isPostRemoved {
                completionHandler(true)
                self.postFavoritesDataProvider.getListByBloggerPost(postIdsFilter: [postId], bloggerIdFilter: nil) { postFavoritesList in
                    if let postFavorites = postFavoritesList[postId] {
                        for postFavorite in postFavorites {
                            self.postFavoritesDataStorage.remove(postFavorite) { isPostFavoriteRemoved in
                            }
                        }
                    }
                }
                self.postCommentDataProvider.getList(limit: nil, postIdFilter: postId, parentIdFilter: nil, beforeCommentedAtFilter: nil) { postComments, hasMoreComments in
                    for postComment in postComments {
                        if let postCommentId = postComment.id {
                            self.postCommentStorage.remove(postCommentId) { isPostCommentRemoved in
                            }
                        }
                    }
                }
                self.postLikeDataProvider.getListByBloggerPost(postIdsFilter: [postId], bloggerIdFilter: nil) { postLikesList in
                    if let postLikes = postLikesList[postId] {
                        for postLike in postLikes {
                            self.postLikeDataStorage.remove(postLike) { isPostLikeRemoved in
                            }
                        }
                    }
                }
            } else {
                print("post #\(postId) was not removed")
            }
        }
    }
    
    fileprivate func aggregatePosts(
        posts: [PostItem],
        hasMore: Bool,
        currentBloggerId: String? = nil,
        completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void
    ) {
        if posts.count > 0 {
            var bloggerIds: [String] = []
            for post in posts {
                bloggerIds.append(post.blogger)
            }
            var postIds: [String] = []
            for post in posts {
                if let postId = post.id {
                    postIds.append(postId)
                }
            }
            self.postLikeDataProvider.getTotalAmount(postIdsFilter: postIds) { postToLikeAmount in
                self.postCommentDataProvider.getTotalAmount(postIdsFilter: postIds) { postToCommentAmount in
                    self.bloggerDataProvider.getByIds(bloggerIds) { bloggers in
                        if let currentBloggerId = currentBloggerId {
                            self.postLikeDataProvider.getListByBloggerPost(postIdsFilter: postIds, bloggerIdFilter: currentBloggerId) { postLikes in
                                self.postFavoritesDataProvider.getListByBloggerPost(postIdsFilter: postIds, bloggerIdFilter: currentBloggerId) { postFavorites in
                                    self.makeAggregatesAndHandle(
                                        posts: posts,
                                        hasMore: hasMore,
                                        bloggers: bloggers,
                                        postToLikeAmount: postToLikeAmount,
                                        postToCommentAmount: postToCommentAmount,
                                        postLikes: postLikes,
                                        postFavorites: postFavorites,
                                        completionHandler: completionHandler
                                    )
                                }
                            }
                        } else {
                            self.makeAggregatesAndHandle(
                                posts: posts,
                                hasMore: hasMore,
                                bloggers: bloggers,
                                postToLikeAmount: postToLikeAmount,
                                postToCommentAmount: postToCommentAmount,
                                postLikes: [:],
                                postFavorites: [:],
                                completionHandler: completionHandler
                            )
                        }
                    }
                }
            }
        } else {
            completionHandler([], false)
        }
    }
    
    fileprivate func makeAggregatesAndHandle(
        posts: [PostItem],
        hasMore: Bool,
        bloggers: [BloggerPreview],
        postToLikeAmount: [String:Int],
        postToCommentAmount: [String:Int],
        postLikes: [String : [PostLike]],
        postFavorites: [String : [PostFavorites]],
        completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void
    ) {
        var postsAggregates: [PostAggregate] = []
        var bloggerIdToBlogger: [String:BloggerPreview] = [:]
        for blogger in bloggers {
            if let bloggerId = blogger.id {
                bloggerIdToBlogger[bloggerId] = blogger
            }
        }
        for post in posts {
            if let postId = post.id {
                if let bloggerItem = bloggerIdToBlogger[post.blogger] {
                    let postFavoritesList = postFavorites[postId] ?? []
                    let postLikesList = postLikes[postId] ?? []
                    let postAggregate = PostAggregate(
                        blogger: bloggerItem,
                        post: post,
                        isLiked: (postLikesList.count > 0) ? true : false,
                        isFavorite: (postFavoritesList.count > 0) ? true : false,
                        commentsAmount: postToCommentAmount[postId] ?? 0,
                        likesAmount: postToLikeAmount[postId] ?? 0,
                        like: postLikesList.first ?? nil,
                        favorite: postFavoritesList.first ?? nil
                    )
                    postsAggregates.append(postAggregate)
                }
            }
        }
        completionHandler(postsAggregates, hasMore)
    }
    
    func getPostCommentAggregateList(limit: Int?, postIdFilter: String, parentIdFilter: String?, beforeCommentedAtFilter: Date?, completionHandler: @escaping ([PostCommentAggregate], Bool) -> Void) {
        var postCommentAggregateList: [PostCommentAggregate] = []
        self.postCommentDataProvider.getList(limit: limit, postIdFilter: postIdFilter, parentIdFilter: parentIdFilter, beforeCommentedAtFilter: beforeCommentedAtFilter) { postComments, hasMore in
            print(postComments)
            if postComments.count > 0 {
                var bloggerIds: [String] = []
                for postComment in postComments {
                    bloggerIds.append(postComment.blogger)
                }
                self.bloggerDataProvider.getByIds(bloggerIds) { bloggers in
                    var bloggerIdToBlogger: [String:BloggerPreview] = [:]
                    for blogger in bloggers {
                        if let bloggerId = blogger.id {
                            bloggerIdToBlogger[bloggerId] = blogger
                        }
                    }
                    for postComment in postComments {
                        if let blogger = bloggerIdToBlogger[postComment.blogger] {
                            postCommentAggregateList.append(PostCommentAggregate(
                                postComment: postComment,
                                blogger: blogger
                            ))
                        }
                    }
                    completionHandler(postCommentAggregateList, hasMore)
                }
            } else {
                completionHandler([], false)
            }
        }
    }
    func likePost(bloggerId: String, postId: String, completionHandler: @escaping (PostLike?) -> Void) {
        let postLikeToCreate = PostLike(blogger: bloggerId, post: postId)
        self.postLikeDataStorage.create(postLikeToCreate) { postLike in
            
            self.postLikeDataProvider.getListByBloggerPost(postIdsFilter: [postId], bloggerIdFilter: bloggerId) { postLikesList in
                var postLikeCreated: PostLike? = nil
                if let postLikes = postLikesList[postId] {
                    postLikeCreated = postLikes.first
                }
                completionHandler(postLikeCreated)
            }
        }
    }
    func favoritePost(bloggerId: String, postId: String, completionHandler: @escaping (PostFavorites?) -> Void) {
        let postFavorites = PostFavorites(blogger: bloggerId, post: postId)
        postFavoritesDataStorage.create(postFavorites) { postFavorites in
            self.postFavoritesDataProvider.getListByBloggerPost(postIdsFilter: [postId], bloggerIdFilter: bloggerId) { postFavoritesList in
                var postFavoriteCreated: PostFavorites? = nil
                if let postFavorites = postFavoritesList[postId] {
                    postFavoriteCreated = postFavorites.first
                }
                completionHandler(postFavoriteCreated)
            }
        }
    }
}
