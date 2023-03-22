import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestorePostDataProvider: PostDataProviderProtocol {
    private let db = Firestore.firestore()
    
    func getList(completionHandler: @escaping ([PostItem]) -> Void) {
        var posts: [PostItem] = []
        
        db.collection("posts").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else if let snapshot = snapshot {
                for document in snapshot.documents {
//                            print("\(document.documentID) => \(document.data())")
                    if let postItem = try? document.data(as: PostItem.self) {
                        print(postItem)
                        posts.append(postItem)
                    } else {
                        print("something went wrong")
                    }
                }
            }
            
            print("Posts list")
            print(posts)
            completionHandler(posts)
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
