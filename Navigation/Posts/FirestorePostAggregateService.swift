import Foundation

class FirestorePostAggregateService: PostAggregateServiceProtocol {
    var bloggerDataProvider: BloggerDataProviderProtocol = FirestoreBloggerDataProvider()
    var postDataProvider: PostDataProviderProtocol = FirestorePostDataProvider()
    var postItemDataStorage: PostItemDataStorageProtocol = FirestorePostItemDataStorage()
    var postLikeDataProvider: PostLikeDataProviderProtocol = FirestorePostLikeDataProvider()
    var postLikeDataStorage: PostLikeDataStorageProtocol = FirestorePostLikeDataStorage()
    var postCommentDataProvider: PostCommentDataProviderProtocol = FirestorePostCommentDataProvider()
    var postCommentStorage: PostCommentStorageProtocol = FirestorePostCommentStorage()
    var postFavoritesDataProvider: PostFavoritesDataProviderProtocol = FirestorePostFavoritesDataProvider()
    var postFavoritesDataStorage: PostFavoritesDataStorageProtocol = FirestorePostFavoritesDataStorage()
}
