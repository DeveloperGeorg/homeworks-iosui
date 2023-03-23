import Foundation

struct BloggerPreview: Codable {
    let id: String
    var name: String
    var imageLink: String
    var shortDescription: String = ""
    
    enum CodingKeys: String, CodingKey {
       case id
       case name
       case imageLink
       case shortDescription
    }
    
    init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = "Some id"
        name = try values.decode(String.self, forKey: .name)
        imageLink = try values.decode(String.self, forKey: .imageLink)
        shortDescription = try values.decode(String.self, forKey: .shortDescription)
    }
    init(id: String, name: String, imageLink: String, shortDescription: String = "") {
        self.id = id
        self.name = name
        self.imageLink = imageLink
        self.shortDescription = shortDescription
    }
}
