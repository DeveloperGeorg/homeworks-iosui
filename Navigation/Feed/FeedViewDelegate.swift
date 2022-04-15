import Foundation

protocol FeedViewDelegate {
    func addPostToFeed(title: String) -> Void
    func setOverworkAlertTimerCounter(_ seconds: Int) -> Void 
}
