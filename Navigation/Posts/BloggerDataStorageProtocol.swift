import Foundation

protocol BloggerDataStorageProtocol {
    func create(_ blogger: BloggerPreview, completionHandler: @escaping (BloggerPreview) -> Void) -> Void
    func update(_ blogger: BloggerPreview, completionHandler: @escaping (Bool) -> Void) -> Void
}
