import Foundation

protocol PostCommentDataProviderProtocol {
    func getList(limit: Int, postIdFilter: String, parentIdFilter: String?, completionHandler: @escaping ([PostComment], _ hasMore: Bool) -> Void)
    func getTotalAmount(postIdsFilter: [String], completionHandler: @escaping ([String:Int]) -> Void)
}
