import Foundation
import Uploadcare

class UploadcareFileUploader: FileUploaderProtocol {
    let uploadcare: Uploadcare
    
    init(withPublicKey: String, secretKey: String) {
        self.uploadcare = Uploadcare(withPublicKey: withPublicKey, secretKey: secretKey)
    }
    
    func uploadFile(_ fileDataToUpload: Data, completionHandler: @escaping (String?, String?) -> Void) {
            print("download debug data finished")
            
            print("Starting upload")
            let fileForUploading = self.uploadcare.file(fromData: fileDataToUpload)
            let task = fileForUploading.upload(withName: UUID().uuidString, store: .store, uploadSignature: nil, { progress in
                print("upload progress: \(progress * 100)%")
            }, { result in
                print("DOWNLOAD RESULT")
                print(result)
                switch result {
                    case .failure(let error):
                        print("UPLOAD ERROR:")
                        print(error.detail)
                        completionHandler(nil, error.detail)
                    case .success(let file):
                        print("UPLOAD SUCCESS:")
                        print(file)
                        completionHandler("https://ucarecdn.com/\(file.uuid)/", nil)
                }
            })
    }
    
    
}
