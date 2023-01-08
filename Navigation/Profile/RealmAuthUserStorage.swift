import Foundation
import RealmSwift

class RealmAuthUserStorage: AuthUserStorageProtocol {
    private let realm = try? Realm()

    func save(_ storedAuthUser: StoredAuthUserProtocol) {
        let authUserToStore = RealmStoredAuthUser(login: storedAuthUser.login, password: storedAuthUser.password)
        realm?.beginWrite()
        realm?.add(authUserToStore, update: .modified)
        try? realm?.commitWrite()
    }
    
    func getLastAuthorized() -> StoredAuthUserProtocol? {
        let lastLoggedIn = realm?.objects(RealmStoredAuthUser.self).sorted(byKeyPath: "lastLoggedInAt", ascending: false).first
        return lastLoggedIn
    }
    
    
}
