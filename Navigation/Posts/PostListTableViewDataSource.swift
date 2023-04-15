import UIKit
import StorageService

class PostListTableViewDataSource: NSObject {
    let forCellReuseIdentifier = "list_post_cell"
    var posts: [PostAggregate] = []
    var currentBloggerId: String?
    var postLikeDataStorage: PostLikeDataStorageProtocol?
    var postFavoritesDataStorage: PostFavoritesDataStorageProtocol?
    var postAggregateService: PostAggregateServiceProtocol?
    var doShowRemoveFunctionality: Bool = false
    
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

    func setPostFavoritesDataStorage(_ postFavoritesDataStorage: PostFavoritesDataStorageProtocol) {
        self.postFavoritesDataStorage = postFavoritesDataStorage
    }
    
    func setPostAggregateService(_ postAggregateService: PostAggregateServiceProtocol) {
        self.postAggregateService = postAggregateService
    }
}

extension PostListTableViewDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: forCellReuseIdentifier, for: indexPath) as! PostItemTableViewCell
        cell.isUserInteractionEnabled = true
        
        let index = Int(indexPath.row)
        let post = self.posts[index] as PostAggregate
        cell.initFromPostItem(post, index: index)
        
        let likeTapGesture = UITapGestureRecognizer(target: self, action: #selector(likeTap))
        cell.likesCounterView.addGestureRecognizer(likeTapGesture)
        
        let favoriteTapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteTap))
        cell.favoriteView.addGestureRecognizer(favoriteTapGesture)
        
        if doShowRemoveFunctionality {
            cell.removePostButton.setButtonTappedCallback({ sender in
                print("remove button tapped: post #\(post.post.id)")
                if let postId = post.post.id {
                    self.postAggregateService?.remove(postId) { isPostRemoved in
                        print("post eas removed")
                    }
                } else {
                    print("no post id #\(post.post.id)")
                }
            })
        } else {
            cell.removePostButton.isHidden = true
        }
        
        return cell
    }
    @objc func likeTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if let currentBloggerId = currentBloggerId {
                if let index = sender.view?.tag {
                    if let postLikeDataStorage = self.postLikeDataStorage {
                        let postAggregate = self.posts[index] as PostAggregate
                        if !postAggregate.isLiked {
                            if let postId = postAggregate.post.id {
                                let postLike = PostLike(blogger: currentBloggerId, post: postId)
                                postLikeDataStorage.create(postLike) { postLike in
                                    print("success like")
                                    print(postLike)
                                    /** @todo set postLike */
                                }
                            } else {
                                print("no post id was got \(postAggregate.post.id)")
                            }
                        } else {
                            print("Post has been liked already. Trying to remove")
                            if let postLike = postAggregate.like {
                                postLikeDataStorage.remove(postLike) { wasRemoved in
                                    print("Remove result \(wasRemoved)")
                                }
                                /** @todo set postLike nil */
                            }
                        }
                    } else {
                        print("no like data storage was set")
                    }
                } else {
                    print("no index was got \(sender.view?.tag)")
                }
            } else {
                print("no current blogger was set \(currentBloggerId)")
            }
            
        }
    }
    @objc func favoriteTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if let currentBloggerId = currentBloggerId {
                if let index = sender.view?.tag {
                    if let postFavoritesDataStorage = self.postFavoritesDataStorage {
                        let postAggregate = self.posts[index] as PostAggregate
                        if !postAggregate.isFavorite {
                            if let postId = postAggregate.post.id {
                                let postFavorites = PostFavorites(blogger: currentBloggerId, post: postId)
                                postFavoritesDataStorage.create(postFavorites) { postFavorites in
                                    print("success favorite")
                                    print(postFavorites)
                                }
                            } else {
                                print("no post id was got \(postAggregate.post.id)")
                            }
                        } else {
                            /** @todo remove vaforite */
                            print("Post has been added in favorite already. Trying to remove")
                            if let postFavorite = postAggregate.favorite {
                                postFavoritesDataStorage.remove(postFavorite) { wasRemoved in
                                    print("Remove result \(wasRemoved)")
                                }
                                /** @todo set postLike nil */
                            }
                        }
                    } else {
                        print("no favorite data storage was set")
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
