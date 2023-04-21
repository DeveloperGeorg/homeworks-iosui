import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostCommentDataProvider: PostCommentDataProviderProtocol {
    private let db = Firestore.firestore()
    
    func getList(limit: Int?, postIdFilter: String, parentIdFilter: String? = nil, beforeCommentedAtFilter: Date? = nil, completionHandler: @escaping ([PostComment], Bool) -> Void) {
        var postComments: [PostComment] = []
        
        var query = db.collection("post-comments")
            .whereField("post", isEqualTo: postIdFilter)
            .order(by: "commentedAt", descending: true)
        
        if let parentIdFilter = parentIdFilter {
            query = query.whereField("parent", isEqualTo: parentIdFilter)
        } else {
            query = query.whereField("parent", isEqualTo: "")
        }
        if let beforeCommentedAtFilter = beforeCommentedAtFilter {
            let beforeCommentedAtFilterTimestamp: Timestamp = Timestamp(date: beforeCommentedAtFilter)
            query = query.whereField("commentedAt", isLessThan: beforeCommentedAtFilterTimestamp)
        }
        
        if let limit = limit {
            query = query
                .limit(to: limit)
        }
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting posts: \(error)")
                completionHandler(postComments, false)
            } else if let snapshot = snapshot {
                let postCommentsDocumentsCount = snapshot.documents.count
                for postCommentDocument in snapshot.documents {
                    if let postComment = try? postCommentDocument.data(as: PostComment.self) {
                        postComments.append(postComment)
                    } else {
                        print("something went wrong during post decoding")
                    }
                }
                var hasMore = false
                if let limit = limit {
                    hasMore = postCommentsDocumentsCount >= limit
                }
                postComments = postComments.sorted(by: { $0.commentedAt >= $1.commentedAt })
                completionHandler(postComments, hasMore)
            } else {
                completionHandler(postComments, false)
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
            }
            
            completionHandler(amount)
        }
    }
}
