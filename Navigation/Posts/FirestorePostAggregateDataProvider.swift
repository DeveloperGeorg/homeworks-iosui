import Foundation

class FirestorePostAggregateDataProvider: PostAggregateDataProviderProtocol {
    private let bloggerDataProvider: BloggerDataProviderProtocol = FirestoreBloggerDataProvider()
    private let postDataProvider: PostDataProviderProtocol = FirestorePostDataProvider()
    private let postLikeDataProvider: PostLikeDataProviderProtocol = FirestorePostLikeDataProvider()
    private let postCommentDataProvider: PostCommentDataProviderProtocol = FirestorePostCommentDataProvider()
    
    func getList(limit: Int, beforePostedAtFilter: Date? = nil, bloggerIdFilter: String? = nil, completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void) {
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
                /** @todo blogger */
                self.postLikeDataProvider.getListByBloggerPost(postIdsFilter: postIds, bloggerIdFilter: "5WSoAxbM6IVfobdPRpAU3PpA0wO2") { postLikes in
                    self.postLikeDataProvider.getTotalAmount(postIdsFilter: postIds) { postToLikeAmount in
                        self.postCommentDataProvider.getTotalAmount(postIdsFilter: postIds) { postToCommentAmount in
                            self.bloggerDataProvider.getByIds(bloggerIds) { bloggers in
                                var postsAggregates: [PostAggregate] = []
                                var bloggerIdToBlogger: [String:BloggerPreview] = [:]
                                for blogger in bloggers {
                                    if let bloggerId = blogger.id {
                                        bloggerIdToBlogger[bloggerId] = blogger
                                    }
                                }
                                for var post in posts {
                                    if let postId = post.id {
                                        if let bloggerItem = bloggerIdToBlogger[post.blogger] {
                                            post.commentsAmount = postToCommentAmount[postId] ?? 0
                                            post.likesAmount = postToLikeAmount[postId] ?? 0
                                            let postAggregate = PostAggregate(
                                                blogger: bloggerItem,
                                                post: post,
                                                isLiked: (postLikes[postId] != nil) ? true : false,
                                                commentsAmount: postToCommentAmount[postId] ?? 0,
                                                likesAmount: postToLikeAmount[postId] ?? 0
                                            )
                                            postsAggregates.append(postAggregate)
                                        }
                                    }
                                }
                                
                                completionHandler(postsAggregates, hasMore)
                            }
                        }
                    }
                }
            } else {
                completionHandler([], false)
            }
        }
    }
    
    
}
