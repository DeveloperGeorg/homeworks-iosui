import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreBloggerDataProvider: BloggerDataProviderProtocol {
    private let db = Firestore.firestore()
    func getByUserId(_ userId: String, completionHandler: @escaping (BloggerPreview?) -> Void) {
        self.db
            .collection("bloggers")
            .limit(to: 1)
            .whereField("userId", isEqualTo: userId)
            .getDocuments() { (snapshot, error) in
                if let error = error as NSError? {
                    print("Error getting blogger: \(error)")
                }
                else {
                    if let bloggerDocument = snapshot?.documents.first {
                        if var bloggerItem = try? bloggerDocument.data(as: BloggerPreview.self) {
                            bloggerItem.id = String(bloggerDocument.documentID)
                            completionHandler(bloggerItem)
                        } else {
                            print("something went wrong during blogger decoding")
                        }
                    }
                }
            }
    }
    
    
}
