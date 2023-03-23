import Foundation

struct PostAggregate {
    let author: BloggerPreview
    let post: PostItem
    
    init(author: BloggerPreview, post: PostItem) {
        self.author = author
        self.post = post
    }
}
