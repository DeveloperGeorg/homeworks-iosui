import Foundation

protocol PostAggregateDataProviderProtocol {
    func getList(
        limit: Int,
        beforePostedAtFilter: Date?,
        bloggerIdFilter: String?,
        currentBloggerId: String?,
        completionHandler: @escaping ([PostAggregate], _ hasMore: Bool) -> Void
    )
}
