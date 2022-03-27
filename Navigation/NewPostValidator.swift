import Foundation

class NewPostValidator {
    public var title: String = "" {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("NewPostTitleWasUpdated"), object: nil, userInfo: ["newPostData": self])
        }
    }
    
    public func check(title: String) -> Bool {
        return !title.isEmpty
    }
}
