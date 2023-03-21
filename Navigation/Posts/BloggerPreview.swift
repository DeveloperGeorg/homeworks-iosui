import Foundation

class BloggerPreview {
    let id: Int
    var name: String
    var imageLink: String
    var shortDescription: String = ""
    init(id: Int, name: String, imageLink: String, shortDescription: String = "") {
        self.id = id
        self.name = name
        self.imageLink = imageLink
        self.shortDescription = shortDescription
    }
}
