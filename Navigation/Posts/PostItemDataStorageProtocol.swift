import Foundation

protocol PostItemDataStorageProtocol {
    func create(_ postItem:PostItem, completionHandler: @escaping (PostItem) -> Void)
    func remove(_ postId: String, completionHandler: @escaping (Bool) -> Void)
}
