import Foundation
import Uploadcare

class UploadcareFileUploader: FileUploaderProtocol {
    let uploadcare: Uploadcare
    
    init(withPublicKey: String, secretKey: String) {
        self.uploadcare = Uploadcare(withPublicKey: withPublicKey,secretKey: secretKey)
    }
    
    func uploadFile(completionHandler: @escaping (String?, String?) -> Void) {
        
        URLSession.shared.dataTask(with: URL(string: "https://source.unsplash.com/random")!) { data, response, error in
                    if let data = data {
                        
                        print("download debug data finished")
                        
                        print("Starting upload")
                        let fileForUploading = self.uploadcare.file(fromData: data)
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

//                        let task = uploadcare.uploadAPI.directUpload(files:  [UUID().uuidString: data], store: .store, metadata: ["someKey": "someMetaValue"]) { progress in
//                            print("upload progress: \(progress * 100)%")
//                        } _: { result in
//                            print("DOWNLOAD RESULT")
//                            print(result)
//                            switch result {
//                            case .failure(let error):
//                                print("UPLOAD ERROR:")
//                                print(error.detail)
//                                print(error)
//                                completionHandler(nil)
//                            case .success(let files):
//                                for file in files {
//                                    print("uploaded file name: \(file.key) | file id: \(file.value)")
//                                    print("UPLOAD SUCCESS:")
//                                    print(file)
//                                    completionHandler(file.value)
//                                }
//                            }
//                        }
                        
//                        let task = uploadcare.uploadFile(data, withName: UUID().uuidString, store: .doNotStore, { progress in
//                            print("upload progress: \(progress * 100)%")
//                        }, { result in
//                            print("DOWNLOAD RESULT")
//                            print(result)
//                            switch result {
//                                case .failure(let error):
//                                    print("UPLOAD ERROR:")
//                                    print(error.detail)
//                                    completionHandler(nil)
//                                case .success(let file):
//                                    print("UPLOAD SUCCESS:")
//                                    print(file)
//                                    completionHandler(file.uuid)
//                            }
//                        }) as? UploadTaskResumable
                    } else {
                        print("download debug error")
                    }
                }.resume()
    }
    
    
}
