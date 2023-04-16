import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreBloggerDataStorage: BloggerDataStorageProtocol {
    private let db = Firestore.firestore()
    
    func create(_ blogger: BloggerPreview, completionHandler: @escaping (BloggerPreview) -> Void) -> Void {
        _ = db.collection("bloggers").addDocument(data: blogger.getDataForFirestore()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                completionHandler(blogger)
            }
        }
    }
    
    func update(_ blogger: BloggerPreview, completionHandler: @escaping (Bool) -> Void) -> Void {
        if let bloggerId = blogger.id {
            db.collection("bloggers").document(bloggerId).setData(blogger.getDataForFirestore()) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                    completionHandler(false)
                } else {
                    completionHandler(true)
                }
            }
        } else {
            completionHandler(false)
        }
    }
}

extension BloggerPreview {
    func getDataForFirestore() -> [String:Any] {
        return [
            "userId": userId,
            "name": name,
            "imageLink": imageLink,
            "shortDescription": shortDescription,
        ]
    }
}
