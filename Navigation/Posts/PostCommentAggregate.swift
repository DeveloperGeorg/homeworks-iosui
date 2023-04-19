import Foundation

class PostCommentAggregate {
    let postComment: PostComment
    let blogger: BloggerPreview
    init(postComment: PostComment, blogger: BloggerPreview) {
        self.postComment = postComment
        self.blogger = blogger
    }
}
