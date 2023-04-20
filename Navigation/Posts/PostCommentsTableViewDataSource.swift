import UIKit

class PostCommentsTableViewDataSource: NSObject {
    let forCellReuseIdentifier = "list_post_comment_cell"
    var postComments: [PostCommentAggregate] = []
    var currentBloggerId: String?
    var currentPostId: String?
    
    override init() {
        self.postComments = []
        self.currentBloggerId = nil
        self.currentPostId = nil
    }
    
    func clearPostComments() {
        self.postComments = []
    }
    
    func addPostComments(_ postComments: [PostCommentAggregate]) {
        self.postComments.append(contentsOf: postComments)
    }
    
    func addPostCommentInTheBeggining(_ postComment: PostCommentAggregate) {
        self.postComments.insert(postComment, at: 0)
    }
}

extension PostCommentsTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postComments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: forCellReuseIdentifier, for: indexPath) as! PostCommentTableViewCell
        
        let index = Int(indexPath.row)
        let postComment = self.postComments[index] as PostCommentAggregate
        cell.initFromPostComment(postComment)

        return cell
    }
}
