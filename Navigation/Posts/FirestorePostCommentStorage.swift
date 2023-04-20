import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostCommentStorage: PostCommentStorageProtocol {
    private let db = Firestore.firestore()
    
    func add(postComment: PostComment, completionHandler: @escaping (PostComment) -> Void) {
        _ = db.collection("post-comments").addDocument(data: postComment.getDataForFirestore()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                completionHandler(postComment)
            }
        }
    }
    
    func remove(_ postCommentId: String, completionHandler: @escaping (Bool) -> Void) {
        db.collection("post-comments").document(postCommentId).delete() { err in
            if let err = err {
                print("Error removing post-comments document: \(err)")
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }
}

extension PostComment {
    func getDataForFirestore() -> [String:Any] {
        return [
            "blogger": blogger,
            "post": post,
            "parent": parent ?? "",
            "comment": comment,
            "commentedAt": Timestamp(date: commentedAt),
        ]
    }
}
