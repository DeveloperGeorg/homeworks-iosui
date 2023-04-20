import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct PostLike: Codable {
    @DocumentID var id: String?
    let blogger: String
    let post: String
    
    enum CodingKeys: String, CodingKey {
       case blogger
       case post
    }
    
    init(blogger: String, post: String) {
        self.blogger = blogger
        self.post = post
    }
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        blogger = try values.decode(String.self, forKey: .blogger)
        post = try values.decode(String.self, forKey: .post)
    }
}
