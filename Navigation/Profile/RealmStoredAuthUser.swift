import Foundation
import RealmSwift

struct RealmStoredAuthUser: StoredAuthUserProtocol {
    var login: String
    
    var password: String
    
    
}
