import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostDataProvider: PostDataProviderProtocol {
    private let db = Firestore.firestore()
    
    func getList(limit: Int, beforePostedAtFilter: Date? = nil, bloggerIdFilter: String? = nil, completionHandler: @escaping ([PostItem], _ hasMore: Bool) -> Void) {
        var posts: [PostItem] = []
        
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
                completionHandler(posts, false)
            } else if let snapshot = snapshot {
                let postDocumentsCount = snapshot.documents.count
                for postDocument in snapshot.documents {
                    if var post = try? postDocument.data(as: PostItem.self) {
                        post.id = String(postDocument.documentID)
                        posts.append(post)
                    } else {
                        print("something went wrong during post decoding")
                    }
                }
                posts = posts.sorted(by: { $0.postedAt >= $1.postedAt })
                completionHandler(posts, postDocumentsCount >= limit)
            }
        }
    }
    
    
    func getListByIds(postIds: [String], completionHandler: @escaping ([PostItem]) -> Void) {
        var postsCounter = 0
        var postList: [PostItem] = []
        for postId in postIds {
            let docRef = db.collection("posts").document(postId)

            docRef.getDocument { (document, error) in
                postsCounter += 1
                if let document = document, document.exists {
                    if var post = try? document.data(as: PostItem.self) {
                        post.id = String(document.documentID)
                        postList.append(post)
                    } else {
                        print("something went wrong during post decoding")
                    }
                } else {
                    print("Document does not exist")
                }
                if postsCounter == postIds.count {
                    postList = postList.sorted(by: {
                        if let firstIndex = postIds.firstIndex(of: $0.id ?? "")  {
                            if let secondIndex = postIds.firstIndex(of: $1.id ?? "")  {
                                return firstIndex <= secondIndex
                            }
                        }
                        return false
                    })
                    completionHandler(postList)
                }
            }
        }
    }
}
