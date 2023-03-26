import Foundation

class FirestorePostAggregateDataProvider: PostAggregateDataProviderProtocol {
    private let bloggerDataProvider: BloggerDataProviderProtocol = FirestoreBloggerDataProvider()
    private let postDataProvider: PostDataProviderProtocol = FirestorePostDataProvider()
    
    func getList(limit: Int, beforePostedAtFilter: Date? = nil, bloggerIdFilter: String? = nil, completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void) {
        self.postDataProvider.getList(limit: limit, beforePostedAtFilter: beforePostedAtFilter, bloggerIdFilter: bloggerIdFilter) { posts, hasMore in
            var bloggerIds: [String] = []
            for post in posts {
                bloggerIds.append(post.blogger)
            }
            
            if posts.count > 0 {
                self.bloggerDataProvider.getByIds(bloggerIds) {bloggers in
                    var postsAggregates: [PostAggregate] = []
                    var bloggerIdToBlogger: [String:BloggerPreview] = [:]
                    for blogger in bloggers {
                        if let bloggerId = blogger.id {
                            bloggerIdToBlogger[bloggerId] = blogger
                        }
                    }
                    for post in posts {
                        if let bloggerItem = bloggerIdToBlogger[post.blogger] {
                            postsAggregates.append(PostAggregate(blogger: bloggerItem, post: post))
                        }
                    }
                    
                    completionHandler(postsAggregates, hasMore)
                }
            }
        }
    }
    
    
}
