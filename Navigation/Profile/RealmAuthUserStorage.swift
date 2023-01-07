import Foundation
import RealmSwift

class RealmAuthUserStorage: AuthUserStorageProtocol {
    private let realm = try? Realm()

    public init() {
        print(Realm.Configuration.defaultConfiguration.fileURL)
    }
    func save(_ storedAuthUser: StoredAuthUserProtocol) {
        let authUserToStore = RealmStoredAuthUser(login: storedAuthUser.login, password: storedAuthUser.password)
//        realm?.beginWrite()
//        realm?.add(authUserToStore)
//        try? realm?.commitWrite()
    }
    
    func getLastAuthorized() -> StoredAuthUserProtocol? {
        return nil
    }
    
    
}
