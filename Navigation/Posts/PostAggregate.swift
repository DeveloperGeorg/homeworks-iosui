import Foundation

struct PostAggregate {
    let blogger: BloggerPreview
    let post: PostItem
    
    init(blogger: BloggerPreview, post: PostItem) {
        self.blogger = blogger
        self.post = post
    }
}
