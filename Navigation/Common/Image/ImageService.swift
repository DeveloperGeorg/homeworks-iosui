import UIKit
import CryptoKit

class ImageService {
    let diskCacheURL: URL
    init() {
        /** @todo move cache to another implementation */
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        self.diskCacheURL = cachesURL.appendingPathComponent("DownloadImageCache")
        if !FileManager.default.fileExists(atPath: self.diskCacheURL.absoluteString) {
            try? FileManager.default.createDirectory(at: self.diskCacheURL, withIntermediateDirectories: true)
        }
    }
    func getUIImageByUrlString(_ url: String, completionHandler: @escaping (_ uiImage: UIImage?) -> Void) {
        DispatchQueue.global().async {
            let hashMD5 = self.md5Hash(url)
            let imageCachedUrl = self.diskCacheURL.appendingPathComponent(self.md5Hash(url))
            var image: UIImage? = nil
            if let url = URL(string: url) {
                if let data = try? Data(contentsOf: imageCachedUrl) {
                    image = UIImage(data: data)
                } else if let data = try? Data(contentsOf: url) {
                    image = UIImage(data: data)
                    do {
                        try data.write(to: imageCachedUrl)
                    } catch {
                        print("Unable to Write Image Data to Disk")
                    }
                }
            }
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }
    }
    
    private func md5Hash(_ source: String) -> String {
        return Insecure.MD5.hash(data: source.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
    }
}
