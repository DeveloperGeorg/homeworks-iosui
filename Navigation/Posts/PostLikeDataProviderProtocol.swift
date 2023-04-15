import Foundation

protocol PostLikeDataProviderProtocol {
    func getListByBloggerPost(postIdsFilter: [String], bloggerIdFilter: String?, completionHandler: @escaping ([String:[PostLike]]) -> Void)
    func getTotalAmount(postIdsFilter: [String], completionHandler: @escaping ([String:Int]) -> Void)
}
