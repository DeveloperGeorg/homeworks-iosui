import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostFavoritesDataStorage: PostFavoritesDataStorageProtocol {
    private let db = Firestore.firestore()
    
    func create(_ postFavorites: PostFavorites, completionHandler: @escaping (PostFavorites?) -> Void) {
        _ = db.collection("post-favorites").addDocument(data: postFavorites.getDataForFirestore()) { err in
            if let err = err {
                print("Error adding document: \(err)")
                completionHandler(nil)
            } else {
                completionHandler(postFavorites)
            }
        }
    }
}

extension PostFavorites {
    func getDataForFirestore() -> [String:Any] {
        return [
            "blogger": blogger,
            "post": post,
            "addedAt": Timestamp(date: addedAt),
        ]
    }
}
