import Foundation

class FirestorePostAggregateService: PostAggregateServiceProtocol {
    var bloggerDataProvider: BloggerDataProviderProtocol = FirestoreBloggerDataProvider()
    var postDataProvider: PostDataProviderProtocol = FirestorePostDataProvider()
    var postLikeDataProvider: PostLikeDataProviderProtocol = FirestorePostLikeDataProvider()
    var postCommentDataProvider: PostCommentDataProviderProtocol = FirestorePostCommentDataProvider()
    var postFavoritesDataProvider: PostFavoritesDataProviderProtocol = FirestorePostFavoritesDataProvider()
}
