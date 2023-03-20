import UIKit

class InfoViewController: UIViewController {
    weak var coordinator: FeedCoordinator?
    
    public init(coordinator: FeedCoordinator?) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    }
    override func loadView() {
        let view = InfoView()
        self.view = view
        view.button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func showAlert()
    {
        coordinator?.showAlert()
    }
}
