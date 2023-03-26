import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct PostItem: Codable {
    @DocumentID var id: String?
    let blogger: String
    var mainImageLink: String
    var content: String = ""
    var likesAmount: Int = 0
    var commentsAmount: Int = 0
    let postedAt: Date
    
    enum CodingKeys: String, CodingKey {
       case blogger
       case mainImageLink
       case content
       case likesAmount
       case commentsAmount
       case postedAt
    }
    init(
        blogger: String,
        mainImageLink: String,
        content: String = "",
        likesAmount: Int = 0,
        commentsAmount: Int = 0,
        postedAt: Date = Date()
    ) {
        self.blogger = blogger
        self.mainImageLink = mainImageLink
        self.content = content
        self.likesAmount = likesAmount
        self.commentsAmount = commentsAmount
        self.postedAt = postedAt
    }
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mainImageLink = try values.decode(String.self, forKey: .mainImageLink)
        content = try values.decode(String.self, forKey: .content)
        likesAmount = try values.decode(Int.self, forKey: .likesAmount)
        commentsAmount = try values.decode(Int.self, forKey: .commentsAmount)
        blogger = try values.decode(String.self, forKey: .blogger)
        postedAt = try values.decode(Timestamp.self, forKey: .postedAt).dateValue()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mainImageLink, forKey: .mainImageLink)
        try container.encode(content, forKey: .content)
        try container.encode(likesAmount, forKey: .likesAmount)
        try container.encode(commentsAmount, forKey: .commentsAmount)
        try container.encode(blogger, forKey: .blogger)
        try container.encode(Timestamp(date: postedAt), forKey: .postedAt)
    }
}
