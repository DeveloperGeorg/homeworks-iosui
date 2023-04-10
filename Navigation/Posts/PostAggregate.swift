import Foundation

struct PostAggregate {
    let blogger: BloggerPreview
    let post: PostItem
    let isLiked: Bool
    let commentsAmount: Int
    let likesAmount: Int
    
    init(blogger: BloggerPreview, post: PostItem, isLiked: Bool, commentsAmount: Int, likesAmount: Int) {
        self.blogger = blogger
        self.post = post
        self.isLiked = isLiked
        self.commentsAmount = commentsAmount
        self.likesAmount = likesAmount
    }
}
