import Foundation

struct PostItem: Codable {
    let author: BloggerPreview
    var mainImageLink: String
    var content: String = ""
    var likesAmount: Int = 0
    var commentsAmount: Int = 0
    let postedAt: Date
    
    enum CodingKeys: String, CodingKey {
       case mainImageLink
       case content
       case likesAmount
       case commentsAmount
//       case postedAt
    }
    
    init(author: BloggerPreview, mainImageLink: String, content: String = "", likesAmount: Int = 0, commentsAmount: Int = 0, postedAt: Date = Date()) {
        self.author = author
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
//        postedAt = try values.decode(Date.self, forKey: .postedAt)
        postedAt = Date()
        author = BloggerPreview(
            id: 1,
            name: "Blogger Two",
            imageLink: "cat-avatar.png",
            shortDescription: "QA"
        )
    }
}
