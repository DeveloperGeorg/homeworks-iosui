import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostLikeDataProvider: PostLikeDataProviderProtocol {
    private let db = Firestore.firestore()
    
    func getListByBloggerPost(postIdsFilter: [String], bloggerIdFilter: String, completionHandler: @escaping ([String:PostLike]) -> Void) {
        
        var postLikes: [String:PostLike] = [:]
            
            var query = db.collection("post-likes")
                .whereField("blogger", isEqualTo: bloggerIdFilter)
                .whereField("post", in: postIdsFilter)
                .limit(to: postIdsFilter.count)
            
            query.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting posts: \(error)")
                } else if let snapshot = snapshot {
                    let postDocumentsCount = snapshot.documents.count
                    for postDocument in snapshot.documents {
                        if var postLike = try? postDocument.data(as: PostLike.self) {
                            postLike.id = String(postDocument.documentID)
                            postLikes[postLike.post] = postLike
                        } else {
                            print("something went wrong during post decoding")
                        }
                    }
                    completionHandler(postLikes)
                }
            }
    }
    
    func getTotalAmount(postIdsFilter: [String], completionHandler: @escaping ([String:Int]) -> Void) {
        var postToAmount: [String:Int] = [:]
        var handledItems = 0
        for postId in postIdsFilter {
            self.getTotalAmountForPost(postIdsFilter: postId) { amount in
                postToAmount[postId] = amount
                handledItems += 1
                if postIdsFilter.count == handledItems {
                    completionHandler(postToAmount)
                }
            }
        }
    }
    
    private func getTotalAmountForPost(postIdsFilter: String, completionHandler: @escaping (Int) -> Void) {
        let query = db.collection("post-likes")
            .whereField("post", isEqualTo: postIdsFilter)

        let countQuery = query.count
        countQuery.getAggregation(source: .server) { snapshot, error  in
            var amount = 0
            if let error = error {
                print("Error getting likes amount for post \(postIdsFilter): \(error)")
            } else if let snapshot = snapshot {
                amount = Int(truncating: snapshot.count)
                print("post #\(postIdsFilter), likes \(amount)")
            }
            
            completionHandler(amount)
        }
    }
}
