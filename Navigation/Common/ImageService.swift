import UIKit

class ImageService {
    func getUIImageByUrlString(_ url: String, completionHandler: @escaping (_ uiImage: UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let url = URL(string: url) {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            completionHandler(image)
                        }
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }
}
