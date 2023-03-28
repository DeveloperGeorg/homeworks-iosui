import Foundation

protocol PostItemDataStorageProtocol {
    func create(_ postItem:PostItem, completionHandler: @escaping (PostItem) -> Void)
}
