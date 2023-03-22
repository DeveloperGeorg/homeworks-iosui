import Foundation

protocol PostDataProviderProtocol {
    func getList(completionHandler: @escaping ([PostItem]) -> Void)
}
