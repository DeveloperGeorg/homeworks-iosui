import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class BloggerPreview: Codable {
    @DocumentID var id: String?
    let userId: String
    var name: String
    var imageLink: String
    var shortDescription: String = ""
    init(userId: String, name: String, imageLink: String, shortDescription: String = "") {
        self.userId = userId
        self.name = name
        self.imageLink = imageLink
        self.shortDescription = shortDescription
    }
    
    
    enum CodingKeys: String, CodingKey {
       case userId
       case name
       case imageLink
       case shortDescription
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decode(String.self, forKey: .userId)
        name = try values.decode(String.self, forKey: .name)
        imageLink = try values.decode(String.self, forKey: .imageLink)
        shortDescription = try values.decode(String.self, forKey: .shortDescription)
    }
}
