import Foundation
import StorageService

protocol PostDataProviderProtocol {
    func getList() -> [Post]
}
