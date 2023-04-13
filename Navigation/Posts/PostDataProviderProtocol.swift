import Foundation

protocol PostDataProviderProtocol {
    func getList(limit: Int, beforePostedAtFilter: Date?, bloggerIdFilter: String?, completionHandler: @escaping ([PostItem], _ hasMore: Bool) -> Void)
    
    func getListByIds(postIds: [String], completionHandler: @escaping ([PostItem]) -> Void)
}
