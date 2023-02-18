import Foundation

class TestUserService: UserService {
    func getUserByFullName(_ fullName: String) -> User? {
        return  User(fullName: String(localized: "Debug User"), avatarImageSrc: "cat-avatar.png", status: String(localized: "debug status"))
    }
}
