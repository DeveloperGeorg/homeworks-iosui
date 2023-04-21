import UIKit
import SnapKit

class FeedView: UIView {
    
    let postsTableView: UITableView = {
        let postsTableView = UITableView.init(frame: .zero, style: .plain)
        postsTableView.translatesAutoresizingMaskIntoConstraints = false
        return postsTableView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        
        self.addSubview(postsTableView)
        NSLayoutConstraint.activate([
            postsTableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            postsTableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
