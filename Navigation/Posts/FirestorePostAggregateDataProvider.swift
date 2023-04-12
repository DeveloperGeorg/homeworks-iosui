import Foundation

class FirestorePostAggregateDataProvider: PostAggregateDataProviderProtocol {
    private let bloggerDataProvider: BloggerDataProviderProtocol = FirestoreBloggerDataProvider()
    private let postDataProvider: PostDataProviderProtocol = FirestorePostDataProvider()
    private let postLikeDataProvider: PostLikeDataProviderProtocol = FirestorePostLikeDataProvider()
    private let postCommentDataProvider: PostCommentDataProviderProtocol = FirestorePostCommentDataProvider()
    private let postFavoritesDataProvider: PostFavoritesDataProviderProtocol = FirestorePostFavoritesDataProvider()
    
    func getList(
        limit: Int,
        beforePostedAtFilter: Date? = nil,
        bloggerIdFilter: String? = nil,
        currentBloggerId: String? = nil,
        completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void
    ) {
        self.postDataProvider.getList(limit: limit, beforePostedAtFilter: beforePostedAtFilter, bloggerIdFilter: bloggerIdFilter) { posts, hasMore in
            
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
    }
    
    fileprivate func makeAggregatesAndHandle(
        posts: [PostItem],
        hasMore: Bool,
        bloggers: [BloggerPreview],
        postToLikeAmount: [String:Int],
        postToCommentAmount: [String:Int],
        postLikes: [String : PostLike],
        postFavorites: [String : PostFavorites],
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
                    let postAggregate = PostAggregate(
                        blogger: bloggerItem,
                        post: post,
                        isLiked: (postLikes[postId] != nil) ? true : false,
                        isFavorite: (postFavorites[postId] != nil) ? true : false,
                        commentsAmount: postToCommentAmount[postId] ?? 0,
                        likesAmount: postToLikeAmount[postId] ?? 0,
                        like: postLikes[postId] ?? nil,
                        favorite: postFavorites[postId] ?? nil
                    )
                    postsAggregates.append(postAggregate)
                }
            }
        }
        
        completionHandler(postsAggregates, hasMore)
    }
    
}
