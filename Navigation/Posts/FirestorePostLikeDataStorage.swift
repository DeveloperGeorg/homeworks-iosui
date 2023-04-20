import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostLikeDataStorage: PostLikeDataStorageProtocol {
    private let db = Firestore.firestore()
    
    func create(_ postLike: PostLike, completionHandler: @escaping (PostLike) -> Void) {
        _ = db.collection("post-likes").addDocument(data: postLike.getDataForFirestore()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                completionHandler(postLike)
            }
        }
    }
    func remove(_ postLike:PostLike, completionHandler: @escaping (Bool) -> Void) {
        if let postLikeId = postLike.id {
            db.collection("post-likes").document(postLikeId).delete() { err in
                if let err = err {
                    print("Error removing post likes document: \(err)")
                    completionHandler(false)
                } else {
                    completionHandler(true)
                }
            }
        } else {
            print("Post like has no id")
            completionHandler(false)
        }
    }
}

extension PostLike {
    func getDataForFirestore() -> [String:Any] {
        return [
            "blogger": blogger,
            "post": post,
        ]
    }
}
