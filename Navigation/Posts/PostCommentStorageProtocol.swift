import Foundation

protocol PostCommentStorageProtocol {
    func add(postComment: PostComment, completionHandler: @escaping (PostComment) -> Void)
}
