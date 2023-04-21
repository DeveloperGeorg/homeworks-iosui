import Foundation

protocol UserService {
    func getUserByFullName(_ fullName: String) -> User?
    func getUserIfAuthorized() -> User?
    func storeCurrentUser(_ user: User)
}
