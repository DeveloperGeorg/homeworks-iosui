import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostFavoritesDataProvider: PostFavoritesDataProviderProtocol {
    private let db = Firestore.firestore()
    
    func getListByBloggerPost(postIdsFilter: [String], bloggerIdFilter: String?, completionHandler: @escaping ([String:[PostFavorites]]) -> Void) {
        
        var postFavorites: [String:[PostFavorites]] = [:]
            
        var query = db.collection("post-favorites")
            .whereField("post", in: postIdsFilter)
            .limit(to: postIdsFilter.count)
        if let bloggerIdFilter = bloggerIdFilter {
            query = query
                .whereField("blogger", isEqualTo: bloggerIdFilter)
        }
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting posts: \(error)")
            } else if let snapshot = snapshot {
                for postDocument in snapshot.documents {
                    if var postFavoritesItem = try? postDocument.data(as: PostFavorites.self) {
                        postFavoritesItem.id = String(postDocument.documentID)
                        if !postFavorites.keys.contains(postFavoritesItem.post) {
                            postFavorites[postFavoritesItem.post] = []
                        }
                        postFavorites[postFavoritesItem.post]!.append(postFavoritesItem)
                    } else {
                        print("something went wrong during post decoding")
                    }
                }
                completionHandler(postFavorites)
            }
        }
    }
    
    func getListByBlogger(limit: Int, bloggerIdFilter: String, beforeAddedAtFilter: Date?, completionHandler: @escaping ([PostFavorites], _ hasMore: Bool) -> Void) {
        var postFavorites: [PostFavorites] = []
        
        let beforeAddedAtFilterTimestamp: Timestamp = Timestamp(date: beforeAddedAtFilter ?? Date())
        let query = db.collection("post-favorites")
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
                    if var postFavoritesItem = try? postDocument.data(as: PostFavorites.self) {
                        postFavoritesItem.id = String(postDocument.documentID)
                        postFavorites.append(postFavoritesItem)
                    } else {
                        print("something went wrong during post decoding")
                    }
                }
                postFavorites = postFavorites.sorted(by: { $0.addedAt >= $1.addedAt })
                completionHandler(postFavorites, postDocumentsCount >= limit)
            }
        }
    }
}
