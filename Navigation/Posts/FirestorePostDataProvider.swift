import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostDataProvider: PostDataProviderProtocol {
    private let db = Firestore.firestore()
    
    func getList(limit: Int, beforePostedAtFilter: Date? = nil, completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void) {
        var posts: [PostAggregate] = []
        
        let beforePostedAtFilterTimestamp: Timestamp = Timestamp(date: beforePostedAtFilter ?? Date())
        db.collection("posts")
            .whereField("postedAt", isLessThan: beforePostedAtFilterTimestamp)
            .order(by: "postedAt", descending: true)
            .limit(to: limit)
            .getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting posts: \(error)")
            } else if let snapshot = snapshot {
                let postDocumentsCount = snapshot.documents.count
                var completedPostsCounter = 0;
                for i in snapshot.documents.indices {
                    if let post = try? snapshot.documents[i].data(as: PostItem.self) {
                        self.db.collection("bloggers").document(post.author).getDocument { blogger, error in
                            if let error = error as NSError? {
                                print("Error getting blogger: \(error)")
                            }
                            else {
                              if let blogger = blogger {
                                  if let bloggerItem = try? blogger.data(as: BloggerPreview.self) {
                                      let postAggregate = PostAggregate(author: bloggerItem, post: post)
                                      posts.append(postAggregate)
                                  } else {
                                      print("something went wrong during blogger decoding")
                                  }
                              }
                            }
                            completedPostsCounter += 1
                            /** that's not the best solusion */
                            /** @todo refactor */
                            if completedPostsCounter == postDocumentsCount {
                                print(postDocumentsCount)
                                print(limit)
                                posts = posts.sorted(by: { $0.post.postedAt >= $1.post.postedAt })
                                completionHandler(posts, postDocumentsCount >= limit)
                                posts = []
                            }
                          }
                    } else {
                        print("something went wrong during post decoding")
                    }
                }
            }
            
        }
    }
    
    
}



//        db.collection("posts").getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .secondsSince1970
//                for document in querySnapshot!.documents {
//                    let book = try document.data(as: PostItem.self)
////                    let decodedBook = try decoder.decode(PostItem.self, from: document.data())
////                    print("\(document.documentID) => \(document.data())")
////                    var data = document.data()
////                    if let index = (data.keys.firstIndex{ data[$0] is FIRTimestamp }) {
////                        // Convert the field to `Timestamp`
////                         let timestamp: Timestamp = data[data.keys[index]] as! Timestamp
////
////                         // Get the seconds of it and replace it on the `copy` of `data`.
////                         data[data.keys[index]] = timestamp.seconds
////
////                    }
////                    guard let dataObj = try? JSONSerialization.data(
////                           withJSONObject: data,
////                           options: .prettyPrinted
////                        ) else { return  }
////                    do {
//////                        let jsonData = try JSONSerialization.data(withJSONObject: document.data())
////                        print("\(document.documentID)")
////                        let jsonString = String(data: dataObj, encoding: .utf8)
////                        let somedata = Data(jsonString!.utf8)
////                        print(somedata)
////                        let post = try decoder.decode([PostItem].self, from: somedata)
////                        posts.append(contentsOf: post)
////                    } catch {
////                        print(error.localizedDescription)
////                    }
//                }
//            }
//        }
