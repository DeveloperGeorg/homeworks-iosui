import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct PostComment: Decodable {
    @DocumentID var id: String?
    let blogger: String
    let post: String
    let parent: String?
    let comment: String
    let commentedAt: Date
    
    enum CodingKeys: String, CodingKey {
       case blogger
       case post
       case parent
       case comment
       case commentedAt
    }
    
    init(blogger: String, post: String, comment: String, commentedAt: Date, parent: String? = nil, id: String? = nil) {
        self.blogger = blogger
        self.post = post
        self.parent = parent
        self.comment = comment
        self.commentedAt = commentedAt
        self.id = id
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        blogger = try values.decode(String.self, forKey: .blogger)
        post = try values.decode(String.self, forKey: .post)
        parent = try values.decode(String.self, forKey: .parent)
        comment = try values.decode(String.self, forKey: .comment)
        commentedAt = try values.decode(Timestamp.self, forKey: .commentedAt).dateValue()
    }
}
