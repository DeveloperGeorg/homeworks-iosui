import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreBloggerDataStorage: BloggerDataStorageProtocol {
    private let db = Firestore.firestore()
    
    func create(_ blogger: BloggerPreview, completionHandler: @escaping (BloggerPreview) -> Void) -> Void {
        var refDocument = db.collection("bloggers").addDocument(data: blogger.getDataForFirestore()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("blogger was created")
                completionHandler(blogger)
            }
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
