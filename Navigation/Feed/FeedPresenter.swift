import Foundation

class FeedPresenter {
    var coordinator: FeedCoordinator
    var feedViewDelegate: FeedViewDelegate?
    
    init(coordinator: FeedCoordinator) {
        self.coordinator = coordinator
    }
    
    public func render() {
        let titles = [
            String(localized: "Post title"),
            String(localized: "New post title")
        ]
        titles.forEach({ title in
            self.feedViewDelegate?.addPostToFeed(title: title)
        })
    }
    
    public func setFeedViewDelegate(_ feedViewDelegate: FeedViewDelegate) {
        self.feedViewDelegate = feedViewDelegate
    }
    
    func openPost(post: PostAggregate) {
        coordinator.openPost(post: post)
    }
}
