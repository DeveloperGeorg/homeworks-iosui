import Foundation

class CurrentUserService: UserService {
    private var storage: [String:User] = [
        "User" : User(fullName: "User", avatarImageSrc: "cat-avatar.png", status: "some state")
    ]
    func getUserByFullName(_ fullName: String) -> User? {
        if let user = storage[fullName] {
            return user
        }
        return nil
    }
}
