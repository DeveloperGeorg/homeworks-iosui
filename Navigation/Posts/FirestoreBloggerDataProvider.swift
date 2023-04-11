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
                    completionHandler(nil)
                }
                else {
                    if let bloggerDocument = snapshot?.documents.first {
                        if var bloggerItem = try? bloggerDocument.data(as: BloggerPreview.self) {
                            bloggerItem.id = String(bloggerDocument.documentID)
                            completionHandler(bloggerItem)
                        } else {
                            print("something went wrong during blogger decoding")
                            completionHandler(nil)
                        }
                    }
                }
            }
    }
    
    func getByIds(_ ids: [String], completionHandler: @escaping (_ bloggers: [BloggerPreview]) -> Void) {
        var bloggers: [BloggerPreview] = []
        db.collection("bloggers")
            .whereField(FieldPath.documentID(), in: ids)
            .limit(to: ids.count)
            .getDocuments() { (snapshot, error) in
            if let error = error {
                print("Error getting posts: \(error)")
                completionHandler([])
            } else if let snapshot = snapshot {
                for bloggerDocument in snapshot.documents {
                    if var blogger = try? bloggerDocument.data(as: BloggerPreview.self) {
                        blogger.id = String(bloggerDocument.documentID)
                        bloggers.append(blogger)
                    }
                }
                completionHandler(bloggers)
            }
        }
    }
}
