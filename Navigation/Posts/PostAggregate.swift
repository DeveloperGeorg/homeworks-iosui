import Foundation

struct PostAggregate {
    let blogger: BloggerPreview
    let post: PostItem
    var isLiked = false
    var commentsAmount = 0
    var likesAmount = 0
    
    init(blogger: BloggerPreview, post: PostItem) {
        self.blogger = blogger
        self.post = post
    }
}
