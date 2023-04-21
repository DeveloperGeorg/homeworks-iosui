import Foundation
import Uploadcare

class UploadcareFileUploader: FileUploaderProtocol {
    private let imageUrlDomain = "https://ucarecdn.com"
    let uploadcare: Uploadcare
    
    init(withPublicKey: String, secretKey: String) {
        self.uploadcare = Uploadcare(withPublicKey: withPublicKey, secretKey: secretKey)
    }
    
    func uploadFile(_ fileDataToUpload: Data, completionHandler: @escaping (String?, String?) -> Void) {
            let fileForUploading = self.uploadcare.file(fromData: fileDataToUpload)
            let task = fileForUploading.upload(withName: UUID().uuidString, store: .store, uploadSignature: nil, { progress in
            }, { result in
                switch result {
                    case .failure(let error):
                        print("UPLOAD ERROR:")
                        print(error.detail)
                        completionHandler(nil, error.detail)
                    case .success(let file):
                        completionHandler("\(self.imageUrlDomain)/\(file.uuid)/", nil)
                }
            })
    }
    
    func getMaxFileSize() -> Int {
        return 1_048_576
    }
    
}
