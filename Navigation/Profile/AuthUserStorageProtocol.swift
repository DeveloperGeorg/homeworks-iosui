import Foundation

protocol AuthUserStorageProtocol {
    func save(_ storedAuthUser: StoredAuthUserProtocol)
    func getLastAuthorized() -> StoredAuthUserProtocol?
}
