import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct PostItem: Decodable {
    @DocumentID var id: String?
    let author: String
    var mainImageLink: String
    var content: String = ""
    var likesAmount: Int = 0
    var commentsAmount: Int = 0
    let postedAt: Date
    
    enum CodingKeys: String, CodingKey {
       case author
       case mainImageLink
       case content
       case likesAmount
       case commentsAmount
       case postedAt
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mainImageLink = try values.decode(String.self, forKey: .mainImageLink)
        content = try values.decode(String.self, forKey: .content)
        likesAmount = try values.decode(Int.self, forKey: .likesAmount)
        commentsAmount = try values.decode(Int.self, forKey: .commentsAmount)
        author = try values.decode(String.self, forKey: .author)
        postedAt = try values.decode(Timestamp.self, forKey: .postedAt).dateValue()
    }
}
