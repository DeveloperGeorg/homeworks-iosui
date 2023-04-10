import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostCommentDataProvider: PostCommentDataProviderProtocol {
    private let db = Firestore.firestore()
    
    func getList(limit: Int, postIdFilter: String, parentIdFilter: String? = nil, completionHandler: @escaping ([PostComment], Bool) -> Void) {
        var postComments: [PostComment] = []
        
        var query = db.collection("post-comments")
            .whereField("post", isEqualTo: postIdFilter)
            .order(by: "commentedAt", descending: true)
            .limit(to: limit)
        
        if let parentIdFilter = parentIdFilter {
            query = query.whereField("parent", isEqualTo: parentIdFilter)
        } else {
            query = query.whereField("parent", isEqualTo: "")
        }
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting posts: \(error)")
            } else if let snapshot = snapshot {
                let postCommentsDocumentsCount = snapshot.documents.count
                for postCommentDocument in snapshot.documents {
                    if var postComment = try? postCommentDocument.data(as: PostComment.self) {
                        postComments.append(postComment)
                    } else {
                        print("something went wrong during post decoding")
                    }
                }
                completionHandler(postComments, postCommentsDocumentsCount >= limit)
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
        let query = db.collection("post-comments")
            .whereField("post", isEqualTo: postIdsFilter)

        let countQuery = query.count
        countQuery.getAggregation(source: .server) { snapshot, error  in
            var amount = 0
            if let error = error {
                print("Error getting comments amount for post \(postIdsFilter): \(error)")
            } else if let snapshot = snapshot {
                amount = Int(truncating: snapshot.count)
                print("post #\(postIdsFilter), comments \(amount)")
            }
            
            completionHandler(amount)
        }
    }
}
