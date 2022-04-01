import Foundation

class TestUserService: UserService {
    func getUserByFullName(_ fullName: String) -> User? {
        return  User(fullName: "Debug User", avatarImageSrc: "cat-avatar.png", status: "debug status")
    }
}
