import Foundation

struct PostAggregate {
    let blogger: BloggerPreview
    let post: PostItem
    let isLiked: Bool
    let isFavorite: Bool
    let commentsAmount: Int
    let likesAmount: Int
    
    init(blogger: BloggerPreview, post: PostItem, isLiked: Bool, isFavorite: Bool, commentsAmount: Int, likesAmount: Int) {
        self.blogger = blogger
        self.post = post
        self.isLiked = isLiked
        self.isFavorite = isFavorite
        self.commentsAmount = commentsAmount
        self.likesAmount = likesAmount
    }
}
