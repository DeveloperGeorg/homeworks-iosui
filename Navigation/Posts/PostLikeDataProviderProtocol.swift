import Foundation

protocol PostLikeDataProviderProtocol {
    func getListByBloggerPost(postIdsFilter: [String], bloggerIdFilter: String, completionHandler: @escaping ([String:PostLike]) -> Void)
}
