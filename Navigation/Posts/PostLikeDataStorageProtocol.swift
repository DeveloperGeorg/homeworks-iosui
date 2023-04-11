import Foundation

protocol PostLikeDataStorageProtocol {
    func create(_ postLike:PostLike, completionHandler: @escaping (PostLike) -> Void)
}
