import Foundation

class PostItem {
    let author: BloggerPreview
    var mainImageLink: String
    var content: String = ""
    var likesAmount: Int = 0
    var commentsAmount: Int = 0
    init(author: BloggerPreview, mainImageLink: String, content: String = "", likesAmount: Int = 0, commentsAmount: Int = 0) {
        self.author = author
        self.mainImageLink = mainImageLink
        self.content = content
        self.likesAmount = likesAmount
        self.commentsAmount = commentsAmount
    }
}
