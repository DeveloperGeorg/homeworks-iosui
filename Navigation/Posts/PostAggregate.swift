import Foundation

struct PostAggregate {
    let blogger: BloggerPreview
    let post: PostItem
    var isLiked: Bool
    var like: PostLike? = nil
    var isFavorite: Bool
    var favorite: PostFavorites? = nil
    let commentsAmount: Int
    let likesAmount: Int
    
    init(blogger: BloggerPreview, post: PostItem, isLiked: Bool, isFavorite: Bool, commentsAmount: Int, likesAmount: Int, like: PostLike? = nil, favorite: PostFavorites? = nil) {
        self.blogger = blogger
        self.post = post
        self.isLiked = isLiked
        self.isFavorite = isFavorite
        self.commentsAmount = commentsAmount
        self.likesAmount = likesAmount
        self.like = like
        self.favorite = favorite
    }
    
    mutating func setLike(_ like: PostLike?) {
        self.like = like
        if self.like == nil {
            self.isLiked = false
        } else {
            self.isLiked = true
        }
    }
    
    mutating func setFavorite(_ favorite: PostFavorites?) {
        self.favorite = favorite
        if self.favorite == nil {
            self.isFavorite = false
        } else {
            self.isFavorite = true
        }
    }
}
