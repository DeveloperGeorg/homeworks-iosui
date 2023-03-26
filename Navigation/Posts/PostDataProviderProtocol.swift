import Foundation

protocol PostDataProviderProtocol {
    func getList(limit: Int, beforePostedAtFilter: Date?, bloggerIdFilter: String?, completionHandler: @escaping ([PostItem], _ hasMore: Bool) -> Void)
}
