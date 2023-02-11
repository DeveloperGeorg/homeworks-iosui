import Foundation
import RealmSwift

class RealmAuthUserStorage: AuthUserStorageProtocol {
    private let realm: Realm?

    public init() {
        let realmService = RealmService()
        self.realm = realmService.getRealm()
    }
    func save(_ storedAuthUser: StoredAuthUserProtocol) {
        let authUserToStore = RealmStoredAuthUser(login: storedAuthUser.login, password: storedAuthUser.password)
        realm?.beginWrite()
        realm?.add(authUserToStore, update: .modified)
        do {
            try realm?.commitWrite()
        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    func getLastAuthorized() -> StoredAuthUserProtocol? {
        let lastLoggedIn = realm?.objects(RealmStoredAuthUser.self).sorted(byKeyPath: "lastLoggedInAt", ascending: false).first
        return lastLoggedIn
    }
    
    
}
