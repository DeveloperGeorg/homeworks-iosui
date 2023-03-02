import Foundation
import UserNotifications

class LocalNotificationsService {
    private let center = UNUserNotificationCenter.current()
    func registeForLatestUpdatesIfPossible() {
        center.requestAuthorization(options: [.sound, .badge, .provisional]) { granted, error in
            if let error = error {
                print("Доступ к уведомлениям не получен")
                print(error)
                return
            }
            self.center.removeAllPendingNotificationRequests()
            self.scheduleNotification()
        }
    }
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        
        content.title = "Посмотрите последние обновления"
        content.body = "Посмотрите последние обновления"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 0
        dateComponents.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        center.add(request)
    }
}
