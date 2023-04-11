import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostFavoritesDataProvider: PostFavoritesDataProviderProtocol {
    private let db = Firestore.firestore()
    
    func getListByBloggerPost(postIdsFilter: [String], bloggerIdFilter: String, completionHandler: @escaping ([String:PostFavorites]) -> Void) {
        
        var postLikes: [String:PostFavorites] = [:]
            
        var query = db.collection("post-favorites")
            .whereField("blogger", isEqualTo: bloggerIdFilter)
            .whereField("post", in: postIdsFilter)
            .limit(to: postIdsFilter.count)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting posts: \(error)")
            } else if let snapshot = snapshot {
                let postDocumentsCount = snapshot.documents.count
                for postDocument in snapshot.documents {
                    if var postLike = try? postDocument.data(as: PostFavorites.self) {
                        postLike.id = String(postDocument.documentID)
                        postLikes[postLike.post] = postLike
                    } else {
                        print("something went wrong during post decoding")
                    }
                }
                completionHandler(postLikes)
            }
        }
    }
    
    func getListByBlogger(limit: Int, bloggerIdFilter: String, beforeAddedAtFilter: Date?, completionHandler: @escaping ([PostFavorites], _ hasMore: Bool) -> Void) {
        var postFavorites: [PostFavorites] = []
        
        let beforeAddedAtFilterTimestamp: Timestamp = Timestamp(date: beforeAddedAtFilter ?? Date())
        var query = db.collection("post-favorites")
            .whereField("addedAt", isLessThan: beforeAddedAtFilterTimestamp)
            .whereField("blogger", isEqualTo: bloggerIdFilter)
            .order(by: "addedAt", descending: true)
            .limit(to: limit)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting posts: \(error)")
            } else if let snapshot = snapshot {
                let postDocumentsCount = snapshot.documents.count
                for postDocument in snapshot.documents {
                    if var post = try? postDocument.data(as: PostFavorites.self) {
                        post.id = String(postDocument.documentID)
                        postFavorites.append(post)
                    } else {
                        print("something went wrong during post decoding")
                    }
                }
                completionHandler(postFavorites, postDocumentsCount >= limit)
            }
        }
    }
}
