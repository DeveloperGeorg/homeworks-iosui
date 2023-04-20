import Foundation

protocol FileUploaderProtocol {
    func uploadFile(_ fileDataToUpload: Data, completionHandler: @escaping (_ fileUrl: String?, _ errorMessage: String?) -> Void)
    func getMaxFileSize() -> Int
}
