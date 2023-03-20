import UIKit
class PostTableViewCell: UITableViewCell {
    fileprivate let maxImageHeight = CGFloat(200)
    var titleView: UILabel = {
        let label = UILabel()
        label.textColor = UiKitFacade.shared.getPrimaryTextColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Custom text"
        label.font = UiKitFacade.shared.getSecondaryTitleFont()
        
        return label
    }()
    var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        /** @todo corner radius */
        return imageView
    }()
    var postImageBlockView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
       return view
    }()
    
    var likesCounterView: UILabel = {
        let label = UILabel()
        label.textColor = UiKitFacade.shared.getPrimaryTextColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UiKitFacade.shared.getRegularTextFont()
        
        return label
    }()
    var viewsCounterView: UILabel = {
        let label = UILabel()
        label.textColor = UiKitFacade.shared.getPrimaryTextColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UiKitFacade.shared.getRegularTextFont()
        
        return label
    }()
    var descriptionView: UITextView = {
        let textView = UITextView()
        textView.textColor = UiKitFacade.shared.getPrimaryTextColor()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UiKitFacade.shared.getSecondaryBackgroundColor()
        postImageBlockView.addSubview(postImageView)
        contentView.addSubviews([
            titleView,
            postImageBlockView,
            likesCounterView,
            viewsCounterView,
            descriptionView
        ])
        contentView.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .black)
        textLabel?.textColor = UIColor.createColor(lightMode: .systemYellow, darkMode: .systemMint)
        
        activateConstraints()
        
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            postImageBlockView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8),
            postImageBlockView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            postImageBlockView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            postImageBlockView.heightAnchor.constraint(equalToConstant: maxImageHeight),
            postImageView.centerXAnchor.constraint(equalTo: postImageBlockView.centerXAnchor, constant: 0),
            postImageView.centerYAnchor.constraint(equalTo: postImageBlockView.centerYAnchor, constant: 0),
            postImageView.heightAnchor.constraint(equalToConstant: maxImageHeight),
            descriptionView.topAnchor.constraint(equalTo: postImageBlockView.bottomAnchor, constant: 8),
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            likesCounterView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 8),
            likesCounterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            likesCounterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            viewsCounterView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 8),
            viewsCounterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            viewsCounterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        accessoryType = .none
    }
}

extension UIView {
    func toAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach{ addSubview($0) }
    }
}
