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
    
}
