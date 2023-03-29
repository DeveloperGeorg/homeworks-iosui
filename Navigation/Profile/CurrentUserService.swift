import Foundation

/** @todo refactor */
class CurrentUserService: UserService {
    private var storage: [String:User] = [
        "User" : User(fullName: String(localized: "User"), avatarImageSrc: "cat-avatar.png", status: String(localized: "some state"))
    ]
    private var storedUser: User? = nil
    func getUserByFullName(_ fullName: String) -> User? {
        if let user = storage[fullName] {
            return user
        }
        return nil
    }
    func getUserIfAuthorized() -> User? {
        return storedUser
    }
    func storeCurrentUser(_ user: User) {
        print("user was stored")
        storedUser = user
    }
}
