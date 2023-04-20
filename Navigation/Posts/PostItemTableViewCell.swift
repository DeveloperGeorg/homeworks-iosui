import UIKit

class PostItemTableViewCell: UITableViewCell {
    var postAggregate: PostAggregate?
    private let imageService: ImageService = ImageService()
    private let textCutter: TextCutter = TextCutter()
    fileprivate let maxImageHeight = CGFloat(200)
    fileprivate let maxAvatarSize = CGFloat(50)
    var authorContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        
       return view
    }()
    var authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25 /** @todo dynamic corner radius */
        
        return imageView
    }()
    var authorImageBlockView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
       return view
    }()
    var authorTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UiKitFacade.shared.getPrimaryTextColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UiKitFacade.shared.getSecondaryTitleFont()
        
        return label
    }()
    var authorSubTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UiKitFacade.shared.getSecondaryTextColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UiKitFacade.shared.getTertiaryTitleFont()
        
        return label
    }()
    var removePostButton: CustomButton = {
        let button = CustomButton(
            title: "",
            titleColor: UiKitFacade.shared.getPrimaryTextColor(),
            titleFor: .normal,
            buttonTappedCallback: nil
        )
        let image = UIImage(systemName: "trash.circle")?.maskWithColor(color: UiKitFacade.shared.getAccentColor())
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var postContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        
       return view
    }()
    
    var anonsContentView: UILabel = {
        let textView = UILabel()
        textView.textColor = UiKitFacade.shared.getPrimaryTextColor()
        textView.font = UiKitFacade.shared.getRegularTextFont()
        textView.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.lineBreakMode = .byWordWrapping
        textView.numberOfLines = 0
        
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
        view.isExclusiveTouch = true
        
       return view
    }()
    var likesCounterLabel: UILabel = {
        let label = UILabel()
        label.textColor = UiKitFacade.shared.getPrimaryTextColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UiKitFacade.shared.getRegularTextFont()
        
        return label
    }()
    let likesImage = UIImage(named: "like-heart")!
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
    
    var favoriteView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isExclusiveTouch = true
        
       return view
    }()
    let favoriteImage = UIImage(named: "favorite")!
    var favoriteCounterIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "favorite")!
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        
        authorImageBlockView.addSubview(authorImageView)
        authorContentView.addSubviews([
            authorImageBlockView,
            authorTitleLabel,
            authorSubTitleLabel,
            removePostButton
        ])
        
        mainImageBlockView.addSubview(mainImageView)
        likesCounterView.addSubviews([
            likesCounterIcon,
            likesCounterLabel
        ])
        commentsCounterView.addSubviews([
            commentsCounterIcon,
            commentsCounterLabel
        ])
        favoriteView.addSubviews([
            favoriteCounterIcon
        ])
        postContentView.addSubviews([
            mainImageBlockView,
            anonsContentView,
            likesCounterView,
            commentsCounterView,
            favoriteView
        ])
        contentView.addSubviews([
            authorContentView,
            postContentView
        ])
        contentView.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        
        activateConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initFromPostItem(_ postAggregate: PostAggregate, index: Int) {
        self.postAggregate = postAggregate
        self.imageService.getUIImageByUrlString(postAggregate.blogger.imageLink) { uiImage in
            self.authorImageView.image = uiImage
        }
            
        authorTitleLabel.text = postAggregate.blogger.name
        authorSubTitleLabel.text = postAggregate.blogger.shortDescription
        anonsContentView.text = textCutter.cut(postAggregate.post.content)
        self.imageService.getUIImageByUrlString(postAggregate.post.mainImageLink) { uiImage in
            self.mainImageView.image = uiImage
        }
        likesCounterLabel.text = "\(postAggregate.likesAmount)"
        likesCounterView.tag = index
        if postAggregate.isLiked {
            if let likeImage = self.likesImage.maskWithColor(color: UiKitFacade.shared.getAccentColor()) {
                likesCounterIcon.image = likeImage
            }
        } else {
            likesCounterIcon.image = self.likesImage
        }
        commentsCounterLabel.text = "\(postAggregate.commentsAmount)"
        favoriteView.tag = index
        if postAggregate.isFavorite {
            if let favoriteImage = favoriteCounterIcon.image?.maskWithColor(color: UiKitFacade.shared.getAccentColor()) {
                favoriteCounterIcon.image = favoriteImage
            }
        } else {
            favoriteCounterIcon.image = self.favoriteImage
        }
    }
    private func activateConstraints() {
        
        NSLayoutConstraint.activate([
            authorContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            authorContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            authorContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            authorContentView.bottomAnchor.constraint(equalTo: authorImageBlockView.bottomAnchor),
            
            authorImageBlockView.topAnchor.constraint(equalTo: authorContentView.topAnchor, constant: UiKitFacade.shared.getConstraintContant(1)),
            authorImageBlockView.leadingAnchor.constraint(equalTo: authorContentView.leadingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            authorImageBlockView.trailingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            authorImageView.heightAnchor.constraint(equalToConstant: maxAvatarSize),
            authorImageView.widthAnchor.constraint(equalToConstant: maxAvatarSize),
            authorImageView.leadingAnchor.constraint(equalTo: authorImageBlockView.leadingAnchor),
            authorImageView.topAnchor.constraint(equalTo: authorImageBlockView.topAnchor),
            authorImageView.bottomAnchor.constraint(equalTo: authorImageBlockView.bottomAnchor),
            
            authorTitleLabel.topAnchor.constraint(equalTo: authorImageBlockView.topAnchor),
            authorTitleLabel.leadingAnchor.constraint(equalTo: authorImageBlockView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            authorTitleLabel.trailingAnchor.constraint(equalTo: removePostButton.leadingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            authorSubTitleLabel.topAnchor.constraint(equalTo: authorTitleLabel.bottomAnchor),
            authorSubTitleLabel.leadingAnchor.constraint(equalTo: authorImageBlockView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            removePostButton.topAnchor.constraint(equalTo: authorImageBlockView.topAnchor),
            removePostButton.trailingAnchor.constraint(equalTo: authorContentView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(-2)),
            
            postContentView.topAnchor.constraint(equalTo: authorContentView.bottomAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            postContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            anonsContentView.topAnchor.constraint(equalTo: postContentView.topAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            anonsContentView.leadingAnchor.constraint(equalTo: postContentView.leadingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            anonsContentView.trailingAnchor.constraint(equalTo: postContentView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(-1)),
            mainImageBlockView.leadingAnchor.constraint(equalTo: postContentView.leadingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            mainImageBlockView.topAnchor.constraint(equalTo: anonsContentView.bottomAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            mainImageBlockView.trailingAnchor.constraint(equalTo: postContentView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(-1)),
            mainImageBlockView.heightAnchor.constraint(equalToConstant: maxImageHeight),
            mainImageView.centerXAnchor.constraint(equalTo: mainImageBlockView.centerXAnchor, constant: 0),
            mainImageView.centerYAnchor.constraint(equalTo: mainImageBlockView.centerYAnchor, constant: 0),
            mainImageView.heightAnchor.constraint(equalToConstant: maxImageHeight),
            
            likesCounterView.topAnchor.constraint(equalTo: mainImageBlockView.bottomAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            likesCounterView.leadingAnchor.constraint(equalTo: postContentView.leadingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            likesCounterView.bottomAnchor.constraint(equalTo: postContentView.bottomAnchor, constant:  UiKitFacade.shared.getConstraintContant(-1)),
            likesCounterView.trailingAnchor.constraint(equalTo: likesCounterLabel.trailingAnchor),
            likesCounterIcon.leadingAnchor.constraint(equalTo: likesCounterView.leadingAnchor),
            likesCounterIcon.topAnchor.constraint(equalTo: likesCounterView.topAnchor),
            likesCounterIcon.bottomAnchor.constraint(equalTo: likesCounterView.bottomAnchor),
            likesCounterLabel.leadingAnchor.constraint(equalTo: likesCounterIcon.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            likesCounterLabel.topAnchor.constraint(equalTo: likesCounterView.topAnchor),
            likesCounterLabel.bottomAnchor.constraint(equalTo: likesCounterView.bottomAnchor),
            
            commentsCounterView.topAnchor.constraint(equalTo: likesCounterView.topAnchor),
            commentsCounterView.leadingAnchor.constraint(equalTo: likesCounterView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            commentsCounterView.bottomAnchor.constraint(equalTo: likesCounterView.bottomAnchor),
            commentsCounterView.trailingAnchor.constraint(equalTo: commentsCounterLabel.trailingAnchor),
            commentsCounterIcon.leadingAnchor.constraint(equalTo: commentsCounterView.leadingAnchor),
            commentsCounterIcon.topAnchor.constraint(equalTo: commentsCounterView.topAnchor),
            commentsCounterIcon.bottomAnchor.constraint(equalTo: commentsCounterView.bottomAnchor),
            commentsCounterLabel.leadingAnchor.constraint(equalTo: commentsCounterIcon.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            commentsCounterLabel.topAnchor.constraint(equalTo: commentsCounterView.topAnchor),
            commentsCounterLabel.bottomAnchor.constraint(equalTo: commentsCounterView.bottomAnchor),
            
            favoriteView.topAnchor.constraint(equalTo: commentsCounterView.topAnchor),
            favoriteView.bottomAnchor.constraint(equalTo: commentsCounterView.bottomAnchor),
            favoriteView.leadingAnchor.constraint(equalTo: favoriteCounterIcon.leadingAnchor),
            favoriteView.trailingAnchor.constraint(equalTo: postContentView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(-2)),
            favoriteCounterIcon.trailingAnchor.constraint(equalTo: favoriteView.trailingAnchor),
            favoriteCounterIcon.topAnchor.constraint(equalTo: favoriteView.topAnchor),
            favoriteCounterIcon.bottomAnchor.constraint(equalTo: favoriteView.bottomAnchor),
        ])
    }
}
