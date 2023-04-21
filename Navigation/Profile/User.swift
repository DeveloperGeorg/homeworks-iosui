import Foundation

class User {
//    let userId: String = "WQpoef1OsQSZALcfZy97puNV9QV2"
    let userId: String
    var avatarImageSrc: String
    var fullName: String
    var status: String
    
    init(userId: String, fullName: String, avatarImageSrc: String, status: String) {
        self.userId = userId
        self.fullName = fullName
        self.avatarImageSrc = avatarImageSrc
        self.status = status
    }
}
