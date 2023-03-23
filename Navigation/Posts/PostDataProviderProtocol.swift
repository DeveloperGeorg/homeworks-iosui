import Foundation

protocol PostDataProviderProtocol {
    func getList(limit: Int, completionHandler: @escaping ([PostAggregate]) -> Void)
}
