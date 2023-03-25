import Foundation

protocol PostDataProviderProtocol {
    func getList(limit: Int, beforePostedAtFilter: Date?, completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void)
}
