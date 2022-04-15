import Foundation

class FeedPresenter {
    var coordinator: FeedCoordinator
    var feedViewDelegate: FeedViewDelegate?
    
    init(coordinator: FeedCoordinator) {
        self.coordinator = coordinator
    }
    
    public func render() {
        let titles = [
            "Post title",
            "New post title"
        ]
        titles.forEach({ title in
            self.feedViewDelegate?.addPostToFeed(title: title)
        })
        Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: #selector(getOverworkAlertTime),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func getOverworkAlertTime() {
        guard let fireDate = OverworkAlertTimer.shared.internalTimer?.fireDate else {
            return
        }
        let nowDate = NSDate()
        var remainingTimeInterval = nowDate.timeIntervalSince(fireDate) * -1
        if (remainingTimeInterval < 0) {
            remainingTimeInterval = 0
        }
        self.feedViewDelegate?.setOverworkAlertTimerCounter(Int(remainingTimeInterval))
    }
    
    public func setFeedViewDelegate(_ feedViewDelegate: FeedViewDelegate) {
        self.feedViewDelegate = feedViewDelegate
    }
    
    func openPost(postTitle: String) {
        coordinator.openPost(postTitle: postTitle)
    }
}
