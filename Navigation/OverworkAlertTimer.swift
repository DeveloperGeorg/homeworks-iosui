import UIKit

class OverworkAlertTimer: NSObject {
    static let shared: OverworkAlertTimer = {
           let timer = OverworkAlertTimer()
            return timer
        }()
    
    var applicationCoordinator: ApplicationCoordinator?
    var internalTimer: Timer?
    var interval: Double = 1
    
    func setApplicationCoordinator(_ applicationCoordinator: ApplicationCoordinator) {
        self.applicationCoordinator = applicationCoordinator
    }
    func startTimer(withInterval interval: Double) {
        if internalTimer != nil {
            internalTimer?.invalidate()
        }
        self.interval = interval
        internalTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(showOverworkAlertTimer), userInfo: nil, repeats: true)
    }

    func pauseTimer() {
        guard internalTimer != nil else {
            print("No timer active, start the timer before you stop it.")
            return
        }
        internalTimer?.invalidate()
    }

    func stopTimer() {
        guard internalTimer != nil else {
            print("No timer active, start the timer before you stop it.")
            return
        }
        internalTimer?.invalidate()
    }

    @objc func showOverworkAlertTimer() -> Void {
        DispatchQueue.main.async {
            self.stopTimer()
            self.applicationCoordinator?.showOverworkAlertTimer(
                okClosure: {
                    self.startTimer(withInterval: self.interval)
                },
                cancelClosure: {
                    self.stopTimer()
                }
            )
        }
    }
}
