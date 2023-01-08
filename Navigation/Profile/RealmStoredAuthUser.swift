import Foundation
import RealmSwift

class RealmStoredAuthUser: Object, StoredAuthUserProtocol {
    @Persisted(primaryKey: true) var login: String
    @Persisted var password: String
    @Persisted var lastLoggedInAt: Date
    
    convenience init(login: String, password: String) {
        self.init()
        self.login = login
        self.password = password
        self.lastLoggedInAt = Date()
    }
}
