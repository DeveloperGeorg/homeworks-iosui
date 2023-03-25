import Foundation

protocol BloggerDataProviderProtocol {
    func getByUserId(_ userId: String, completionHandler: @escaping (_ blogger: BloggerPreview?) -> Void)
}
