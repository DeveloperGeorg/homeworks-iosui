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
extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}
