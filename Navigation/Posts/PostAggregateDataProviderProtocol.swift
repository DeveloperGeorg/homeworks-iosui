import Foundation

protocol PostAggregateDataProviderProtocol {
    func getList(limit: Int, beforePostedAtFilter: Date?, bloggerIdFilter: String?, completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void)
}
