import Foundation

protocol UserService {
    func getUserByFullName(_ fullName: String) -> User?
}
