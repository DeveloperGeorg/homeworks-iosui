import UIKit
import StorageService

class PostListTableViewDataSource: NSObject {
    let forCellReuseIdentifier = "list_post_cell"
    var posts: [PostItem] = []
    override init() {
        self.posts = []
        var postItems: [PostItem] = []
        self.posts = postItems
    }
    
    func addPosts(_ posts: [PostItem]) {
        self.posts.append(contentsOf: posts)
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
        cell.initFromPostItem(post)
        
        return cell
    }
}
