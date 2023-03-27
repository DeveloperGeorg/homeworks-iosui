import Foundation

protocol FileUploaderProtocol {
    func uploadFile(completionHandler: @escaping (_ fileUrl: String?, _ errorMessage: String?) -> Void)
}
