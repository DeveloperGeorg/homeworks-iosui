import Foundation

class User {
    var avatarImageSrc: String
    var fullName: String
    var status: String
    
    init(fullName: String, avatarImageSrc: String, status: String) {
        self.fullName = fullName
        self.avatarImageSrc = avatarImageSrc
        self.status = status
    }
}
