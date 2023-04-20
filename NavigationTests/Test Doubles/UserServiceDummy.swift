import Foundation

class UserServiceDummy: UserService {
    var returnUser: User?
    init(returnUser: User? = nil) {
        self.returnUser = returnUser
    }
    func getUserByFullName(_ fullName: String) -> User? {
        return returnUser
    }
    
    func getUserIfAuthorized() -> User? {
        return returnUser
    }
    
    func storeCurrentUser(_ user: User) {
        returnUser = user
    }
}
