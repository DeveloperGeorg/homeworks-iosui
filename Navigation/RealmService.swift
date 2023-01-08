import Foundation
import RealmSwift

class RealmService {
    let keychainIdentifier = "io.Realm.EncryptionKey"

    func getRealm() -> Realm {
        let key = getEncryptionKey()
        print("encryption key")
        print(key.map { String(format: "%02x", $0) }.joined())
        var config = Realm.Configuration.defaultConfiguration
        config.encryptionKey = key
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
        do {
            let realm = try Realm(configuration: config)
            return realm
        } catch let error as NSError {
            fatalError("Error opening realm: \(error)")
        }
    }

    func getEncryptionKey() -> Data {
        if let keyFromKeyChain = self.getEncryptionKeyFromKeychain() {
            return keyFromKeyChain
        }
        let key = self.generateEncryptionKey()
        self.storeEncryptionKeyInKeychain(key)
        return key
    }

    private func generateEncryptionKey() -> Data {
        var key = Data(count: 64)
        key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
            let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            assert(result == 0, "Failed to get random bytes")
        })
        return key
    }

    private func getEncryptionKeyFromKeychain() -> Data? {
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as? Data
        }
        return nil
    }

    private func storeEncryptionKeyInKeychain(_ key: Data) {
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        var query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: key as AnyObject
        ]
        var status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
    }
}
