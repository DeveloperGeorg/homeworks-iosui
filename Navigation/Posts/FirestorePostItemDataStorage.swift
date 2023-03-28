import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostItemDataStorage: PostItemDataStorageProtocol {
    private let db = Firestore.firestore()
    
    func create(_ postItem: PostItem, completionHandler: @escaping (PostItem) -> Void) {
        var refDocument = db.collection("posts").addDocument(data: postItem.getDataForFirestore()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
//                print("Document added with ID: \(refDocument.documentID)")
                print("Document added:")
                completionHandler(postItem)
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
            "likesAmount": likesAmount,
            "commentsAmount": commentsAmount,
            "blogger": blogger,
            "postedAt": Timestamp(date: postedAt),
        ]
    }
}
