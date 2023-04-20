import Foundation

class PostAggregate: NSObject {
    let blogger: BloggerPreview
    let post: PostItem
    @objc dynamic var isLiked: Bool
    var like: PostLike? = nil
    @objc dynamic var isFavorite: Bool
    var favorite: PostFavorites? = nil
    var commentsAmount: Int
    var likesAmount: Int
    
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
    
    func setLike(_ like: PostLike?) {
        self.like = like
        if self.like == nil {
            self.isLiked = false
            self.likesAmount -= 1
        } else {
            self.isLiked = true
            self.likesAmount += 1
        }
    }
    
    func setFavorite(_ favorite: PostFavorites?) {
        self.favorite = favorite
        if self.favorite == nil {
            self.isFavorite = false
        } else {
            self.isFavorite = true
        }
    }
}
