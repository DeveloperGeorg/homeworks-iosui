import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct BloggerPreview: Codable {
    @DocumentID var id: String?
    var name: String
    var imageLink: String
    var shortDescription: String = ""
    init(id: String, name: String, imageLink: String, shortDescription: String = "") {
        self.id = id
        self.name = name
        self.imageLink = imageLink
        self.shortDescription = shortDescription
    }
    
    
    enum CodingKeys: String, CodingKey {
       case name
       case imageLink
       case shortDescription
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        imageLink = try values.decode(String.self, forKey: .imageLink)
        shortDescription = try values.decode(String.self, forKey: .shortDescription)
    }
}
