import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostDataProvider: PostDataProviderProtocol {
    private let db = Firestore.firestore()
    
    func getList(limit: Int, completionHandler: @escaping ([PostAggregate]) -> Void) {
        var posts: [PostAggregate] = []
        
        db.collection("posts")
//            .order(by: "postedAt", descending: true)
//            .limit(to: limit)
            .getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting posts: \(error)")
            } else if let snapshot = snapshot {
                let lastPostsIndex = snapshot.documents.count - 1
                for i in snapshot.documents.indices {
                    if let post = try? snapshot.documents[i].data(as: PostItem.self) {
                        print(post)
                        self.db.collection("bloggers").document(post.author).getDocument { blogger, error in
                            if let error = error as NSError? {
                                print("Error getting blogger: \(error)")
                            }
                            else {
                              if let blogger = blogger {
                                  if let bloggerItem = try? blogger.data(as: BloggerPreview.self) {
                                      print(bloggerItem)
                                      let postAggregate = PostAggregate(author: bloggerItem, post: post)
                                      print(postAggregate)
                                      posts.append(postAggregate)
                                      print("posts amount \(posts.count)")
                                  } else {
                                      print("something went wrong during blogger decoding")
                                  }
                                  /** that's not the best solusion */
                                  /** @todo refactor */
                                  if i == lastPostsIndex {
                                      print("Posts list")
                                      print(posts)
                                      completionHandler(posts)
                                  }
                              }
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
