import Foundation

protocol BloggerDataProviderProtocol {
    func getByUserId(_ userId: String, completionHandler: @escaping (_ blogger: BloggerPreview?) -> Void)
    func getIds(_ ids: [String], completionHandler: @escaping (_ bloggers: [BloggerPreview]) -> Void)
}
