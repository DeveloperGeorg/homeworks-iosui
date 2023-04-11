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
}

extension PostLike {
    func getDataForFirestore() -> [String:Any] {
        return [
            "blogger": blogger,
            "post": post,
        ]
    }
}
