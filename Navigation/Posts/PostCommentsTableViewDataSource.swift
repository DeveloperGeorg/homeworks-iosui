import UIKit

class PostCommentsTableViewDataSource: NSObject {
    let forCellReuseIdentifier = "list_post_comment_cell"
    var postComments: [PostComment] = []
    var currentBloggerId: String?
    var currentPostId: String?
    
    override init() {
        self.postComments = [
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date()),
            PostComment(blogger: "asdasd", post: "asdasd", comment: "test", commentedAt: Date())
        ]
        self.currentBloggerId = nil
        self.currentPostId = nil
    }
    
    func clearPostComments() {
        self.postComments = []
    }
    
    func addPosts(_ postComments: [PostComment]) {
        self.postComments.append(contentsOf: postComments)
    }
}

extension PostCommentsTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postComments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: forCellReuseIdentifier, for: indexPath) as! PostCommentTableViewCell
        
        let index = Int(indexPath.row)
        let postComment = self.postComments[index] as PostComment
        cell.initFromPostComment(postComment)

        return cell
    }
}
