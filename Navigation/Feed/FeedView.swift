import UIKit

class FeedView: UIView {
    var postsStackView: UIStackView = {
        let postsStackView = UIStackView()
        postsStackView.translatesAutoresizingMaskIntoConstraints = false
        postsStackView.axis = .vertical
        postsStackView.spacing = 10
        return postsStackView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
        
        addSubview(postsStackView)
        postsStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        postsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    public func getButtonWithText(_ text: String) -> UIButton
    {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .white
        button.setTitle(text, for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder) has not been implemented")
    }
}
