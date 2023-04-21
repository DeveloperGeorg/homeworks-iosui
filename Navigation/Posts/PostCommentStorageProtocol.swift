import Foundation

protocol PostCommentStorageProtocol {
    func add(postComment: PostComment, completionHandler: @escaping (PostComment) -> Void)
    func remove(_ postCommentId: String, completionHandler: @escaping (Bool) -> Void)
}
