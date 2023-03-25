import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostDataProvider: PostDataProviderProtocol {
    private let db = Firestore.firestore()
    
    func getList(limit: Int, beforePostedAtFilter: Date? = nil, bloggerIdFilter: String? = nil, completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void) {
        var posts: [PostAggregate] = []
        
        let beforePostedAtFilterTimestamp: Timestamp = Timestamp(date: beforePostedAtFilter ?? Date())
        var query = db.collection("posts")
            .whereField("postedAt", isLessThan: beforePostedAtFilterTimestamp)
            .order(by: "postedAt", descending: true)
            .limit(to: limit)
        
        if let bloggerIdFilter = bloggerIdFilter {
            query = query.whereField("blogger", isEqualTo: bloggerIdFilter)
        }
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting posts: \(error)")
            } else if let snapshot = snapshot {
                let postDocumentsCount = snapshot.documents.count
                var completedPostsCounter = 0;
                for postDocument in snapshot.documents {
                    if var post = try? postDocument.data(as: PostItem.self) {
                        post.id = String(postDocument.documentID)
                        self.db.collection("bloggers").document(post.blogger).getDocument { bloggerDocument, error in
                            if let error = error as NSError? {
                                print("Error getting blogger: \(error)")
                            }
                            else {
                              if let bloggerDocument = bloggerDocument {
                                  if var bloggerItem = try? bloggerDocument.data(as: BloggerPreview.self) {
                                      bloggerItem.id = String(bloggerDocument.documentID)
                                      let postAggregate = PostAggregate(blogger: bloggerItem, post: post)
                                      posts.append(postAggregate)
                                  } else {
                                      print("something went wrong during blogger decoding")
                                  }
                              }
                            }
                            completedPostsCounter += 1
                            /** that's not the best solusion */
                            /** @todo refactor */
                            if completedPostsCounter == postDocumentsCount {
                                posts = posts.sorted(by: { $0.post.postedAt >= $1.post.postedAt })
                                completionHandler(posts, postDocumentsCount >= limit)
                                posts = []
                            }
                          }
                    } else {
                        print("something went wrong during post decoding")
                    }
                }
            }
            
        }
    }
    
    
}
