import Foundation

protocol PostFavoritesDataStorageProtocol {
    func create(_ postFavorites:PostFavorites, completionHandler: @escaping (PostFavorites?) -> Void)
    func remove(_ postFavorites:PostFavorites, completionHandler: @escaping (Bool) -> Void)
}
