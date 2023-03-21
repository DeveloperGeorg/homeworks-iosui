import UIKit

class PostItemTableViewCell: UITableViewCell {
    fileprivate let maxImageHeight = CGFloat(200)
        /** @todo blogger preview block */
    var anonsContentView: UITextView = {
        let textView = UITextView()
        textView.textColor = UiKitFacade.shared.getPrimaryTextColor()
        textView.font = UiKitFacade.shared.getRegularTextFont()
        textView.backgroundColor = UiKitFacade.shared.getSecondaryBackgroundColor()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        
        return textView
    }()
    var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        /** @todo corner radius */
        return imageView
    }()
    var mainImageBlockView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
       return view
    }()
    
    var likesCounterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
       return view
    }()
    var likesCounterLabel: UILabel = {
        let label = UILabel()
        label.textColor = UiKitFacade.shared.getPrimaryTextColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UiKitFacade.shared.getRegularTextFont()
        
        return label
    }()
    var likesCounterIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "like-heart")!
        return imageView
    }()
    
    var commentsCounterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
       return view
    }()
    var commentsCounterLabel: UILabel = {
        let label = UILabel()
        label.textColor = UiKitFacade.shared.getPrimaryTextColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UiKitFacade.shared.getRegularTextFont()
        
        return label
    }()
    var commentsCounterIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "speech-bubble")!
        return imageView
    }()
    
    /** @todo favorite block */
    var favoriteCounterIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "favorite")!
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UiKitFacade.shared.getSecondaryBackgroundColor()
        mainImageBlockView.addSubview(mainImageView)
        likesCounterView.addSubviews([
            likesCounterIcon,
            likesCounterLabel
        ])
        commentsCounterView.addSubviews([
            commentsCounterIcon,
            commentsCounterLabel
        ])
        contentView.addSubviews([
            mainImageBlockView,
            anonsContentView,
            likesCounterView,
            commentsCounterView,
            favoriteCounterIcon
        ])
        contentView.backgroundColor = UiKitFacade.shared.getSecondaryBackgroundColor()
        
        activateConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            
            mainImageBlockView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainImageBlockView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainImageBlockView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainImageBlockView.heightAnchor.constraint(equalToConstant: maxImageHeight),
            mainImageView.centerXAnchor.constraint(equalTo: mainImageBlockView.centerXAnchor, constant: 0),
            mainImageView.centerYAnchor.constraint(equalTo: mainImageBlockView.centerYAnchor, constant: 0),
            mainImageView.heightAnchor.constraint(equalToConstant: maxImageHeight),
            anonsContentView.topAnchor.constraint(equalTo: mainImageBlockView.bottomAnchor, constant: 8),
            anonsContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            anonsContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            likesCounterView.topAnchor.constraint(equalTo: anonsContentView.bottomAnchor, constant: 8),
            likesCounterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            likesCounterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            likesCounterView.trailingAnchor.constraint(equalTo: likesCounterLabel.trailingAnchor),
            likesCounterIcon.leadingAnchor.constraint(equalTo: likesCounterView.leadingAnchor),
            likesCounterIcon.topAnchor.constraint(equalTo: likesCounterView.topAnchor),
            likesCounterIcon.bottomAnchor.constraint(equalTo: likesCounterView.bottomAnchor),
            likesCounterLabel.leadingAnchor.constraint(equalTo: likesCounterIcon.trailingAnchor, constant: 8),
            likesCounterLabel.topAnchor.constraint(equalTo: likesCounterView.topAnchor),
            likesCounterLabel.bottomAnchor.constraint(equalTo: likesCounterView.bottomAnchor),
            
            commentsCounterView.topAnchor.constraint(equalTo: likesCounterView.topAnchor),
            commentsCounterView.leadingAnchor.constraint(equalTo: likesCounterView.trailingAnchor, constant: 8),
            commentsCounterView.bottomAnchor.constraint(equalTo: likesCounterView.bottomAnchor),
            commentsCounterView.trailingAnchor.constraint(equalTo: commentsCounterLabel.trailingAnchor),
            commentsCounterIcon.leadingAnchor.constraint(equalTo: commentsCounterView.leadingAnchor),
            commentsCounterIcon.topAnchor.constraint(equalTo: commentsCounterView.topAnchor),
            commentsCounterIcon.bottomAnchor.constraint(equalTo: commentsCounterView.bottomAnchor),
            commentsCounterLabel.leadingAnchor.constraint(equalTo: commentsCounterIcon.trailingAnchor, constant: 8),
            commentsCounterLabel.topAnchor.constraint(equalTo: commentsCounterView.topAnchor),
            commentsCounterLabel.bottomAnchor.constraint(equalTo: commentsCounterView.bottomAnchor),
            
            favoriteCounterIcon.topAnchor.constraint(equalTo: likesCounterView.topAnchor),
            favoriteCounterIcon.bottomAnchor.constraint(equalTo: likesCounterView.bottomAnchor),
            favoriteCounterIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
}
