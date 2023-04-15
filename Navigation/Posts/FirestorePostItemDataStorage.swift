import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostItemDataStorage: PostItemDataStorageProtocol {
    private let db = Firestore.firestore()
    
    func create(_ postItem: PostItem, completionHandler: @escaping (PostItem) -> Void) {
        _ = db.collection("posts").addDocument(data: postItem.getDataForFirestore()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                completionHandler(postItem)
            }
        }
    }
    
    func remove(_ postId: String, completionHandler: @escaping (Bool) -> Void) {
        db.collection("posts").document(postId).delete() { err in
            if let err = err {
                print("Error removing posts document: \(err)")
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }
}

extension PostItem {
    /** @duct tape cause Firestore wants timestamp field to be Timestamp type (not json) */
    func getDataForFirestore() -> [String:Any] {
        return [
            "mainImageLink": mainImageLink,
            "content": content,
            "blogger": blogger,
            "postedAt": Timestamp(date: postedAt),
        ]
    }
}
