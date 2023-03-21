import UIKit
import StorageService

class PostListTableViewDataSource: NSObject {
    let forCellReuseIdentifier = "list_post_cell"
    var posts: [PostItem] = []
    let postDataProviderProtocol: PostDataProviderProtocol
    override init() {
        self.postDataProviderProtocol = DebugPostDataProvider()
        self.posts = postDataProviderProtocol.getList()
    }
}

extension PostListTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: forCellReuseIdentifier, for: indexPath) as! PostItemTableViewCell
        
        let index = Int(indexPath.row)
        let post = self.posts[index] as PostItem
        cell.anonsContentView.text = post.content
        let image = UIImage(named: post.mainImageLink)
        cell.mainImageView.image = image
        cell.likesCounterView.text = "Likes: \(post.likesAmount)"
        cell.commentsCounterView.text = "Views: \(post.commentsAmount)"
        
        return cell
    }
}
