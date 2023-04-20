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
    
    func remove(_ postFavorites:PostFavorites, completionHandler: @escaping (Bool) -> Void) {
        if let postFavoritesId = postFavorites.id {
            db.collection("post-favorites").document(postFavoritesId).delete() { err in
                if let err = err {
                    print("Error removing post favorites document: \(err)")
                    completionHandler(false)
                } else {
                    completionHandler(true)
                }
            }
        } else {
            print("Post favorite has no id")
            completionHandler(false)
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
