import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct PostFavorites: Codable {
    @DocumentID var id: String?
    let blogger: String
    let post: String
    let addedAt: Date
    
    enum CodingKeys: String, CodingKey {
       case blogger
       case post
       case addedAt
    }
    
    init(blogger: String, post: String, addedAt: Date = Date()) {
        self.blogger = blogger
        self.post = post
        self.addedAt = addedAt
    }
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        blogger = try values.decode(String.self, forKey: .blogger)
        post = try values.decode(String.self, forKey: .post)
        addedAt = try values.decode(Timestamp.self, forKey: .addedAt).dateValue()
    }
}
