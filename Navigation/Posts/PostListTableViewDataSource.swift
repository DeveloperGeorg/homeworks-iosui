import UIKit
import StorageService

class PostListTableViewDataSource: NSObject {
    let forCellReuseIdentifier = "list_post_cell"
    var posts: [PostAggregate] = []
    var currentBloggerId: String?
    var postLikeDataStorage: PostLikeDataStorageProtocol?
    override init() {
        self.posts = []
        self.currentBloggerId = nil
    }
    
    func clearPosts() {
        self.posts = []
    }
    
    func addPosts(_ posts: [PostAggregate]) {
        self.posts.append(contentsOf: posts)
    }
    
    func setCurrentBloggerId(_ currentBloggerId: String?) {
        self.currentBloggerId = currentBloggerId
    }
    
    func setPostLikeDataStorage(_ postLikeDataStorage: PostLikeDataStorageProtocol) {
        self.postLikeDataStorage = postLikeDataStorage
    }
}

extension PostListTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: forCellReuseIdentifier, for: indexPath) as! PostItemTableViewCell
        
        let index = Int(indexPath.row)
        let post = self.posts[index] as PostAggregate
        cell.initFromPostItem(post, index: index)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        cell.likesCounterView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if let currentBloggerId = currentBloggerId {
                if let index = sender.view?.tag {
                    let post = self.posts[index] as PostAggregate
                    if let postId = post.post.id {
                        if let postLikeDataStorage = self.postLikeDataStorage {
                            let postLike = PostLike(blogger: currentBloggerId, post: postId)
                            self.postLikeDataStorage?.create(postLike) { postLike in
                                print("success like")
                                print(postLike)
                            }
                        } else {
                            print("no like data storage was set")
                        }
                    } else {
                        print("no post id was got \(post.post.id)")
                    }
                } else {
                    print("no index was got \(sender.view?.tag)")
                }
            } else {
                print("no current blogger was set \(currentBloggerId)")
            }
            
        }
    }
}
