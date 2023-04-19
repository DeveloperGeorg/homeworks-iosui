import UIKit

class PostAggregateView: UIView {
    private let imageService: ImageService = ImageService()
    fileprivate let maxImageHeight = CGFloat(200)
    fileprivate let maxAvatarSize = CGFloat(50)
    let postAggregate: PostAggregate
    
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
    
    var postContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UiKitFacade.shared.getSecondaryBackgroundColor()
        
       return view
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
    
    var anonsContentView: UILabel = {
        let textView = UILabel()
        textView.textColor = UiKitFacade.shared.getPrimaryTextColor()
        textView.font = UiKitFacade.shared.getRegularTextFont()
        textView.backgroundColor = UiKitFacade.shared.getSecondaryBackgroundColor()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.lineBreakMode = .byWordWrapping
        textView.numberOfLines = 0
        
        return textView
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
    var favoriteCounterIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "favorite")!
        return imageView
    }()

    public init(_ postAggregate: PostAggregate, frame: CGRect) {
        self.postAggregate = postAggregate
        
        super.init(frame: frame)
        self.imageService.getUIImageByUrlString(postAggregate.blogger.imageLink) { uiImage in
            self.authorImageView.image = uiImage
        }
        
        self.authorTitleLabel.text = postAggregate.blogger.name
        self.authorSubTitleLabel.text = postAggregate.blogger.shortDescription
        self.anonsContentView.text = postAggregate.post.content
        self.imageService.getUIImageByUrlString(postAggregate.post.mainImageLink) { uiImage in
            self.mainImageView.image = uiImage
        }
        self.likesCounterLabel.text = "\(postAggregate.likesAmount)"
        self.commentsCounterLabel.text = "\(postAggregate.commentsAmount)"
        self.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews()
        self.activateConstraints()
    }
    
    private func addSubviews() {
        authorImageBlockView.addSubview(authorImageView)
        authorContentView.addSubviews([
            authorImageBlockView,
            authorTitleLabel,
            authorSubTitleLabel
        ])
        
        mainImageBlockView.addSubview(mainImageView)
//        likesCounterView.addSubviews([
//            likesCounterIcon,
//            likesCounterLabel
//        ])
//        commentsCounterView.addSubviews([
//            commentsCounterIcon,
//            commentsCounterLabel
//        ])
//        favoriteView.addSubviews([
//            favoriteCounterIcon
//        ])
        postContentView.addSubviews([
            mainImageBlockView,
            anonsContentView,
//            likesCounterView,
//            commentsCounterView,
//            favoriteView
        ])
        self.addSubviews([
            authorContentView,
            postContentView
        ])
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            
            authorContentView.topAnchor.constraint(equalTo: self.topAnchor),
            authorContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            authorContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
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
            authorTitleLabel.trailingAnchor.constraint(equalTo: authorContentView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            authorSubTitleLabel.topAnchor.constraint(equalTo: authorTitleLabel.bottomAnchor),
            authorSubTitleLabel.leadingAnchor.constraint(equalTo: authorImageBlockView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            
            postContentView.topAnchor.constraint(equalTo: authorContentView.bottomAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            postContentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            postContentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            postContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor), //@todo remove and self.bottomAnchor set as postContentView.bottomAnchor
            mainImageBlockView.topAnchor.constraint(equalTo: postContentView.topAnchor),
            mainImageBlockView.leadingAnchor.constraint(equalTo: postContentView.leadingAnchor),
            mainImageBlockView.trailingAnchor.constraint(equalTo: postContentView.trailingAnchor),
            mainImageBlockView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            mainImageView.centerXAnchor.constraint(equalTo: mainImageBlockView.centerXAnchor, constant: 0),
            mainImageView.centerYAnchor.constraint(equalTo: mainImageBlockView.centerYAnchor, constant: 0),
            mainImageView.heightAnchor.constraint(equalToConstant: maxImageHeight),
            
            anonsContentView.topAnchor.constraint(equalTo: mainImageBlockView.bottomAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            anonsContentView.leadingAnchor.constraint(equalTo: postContentView.leadingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
            anonsContentView.trailingAnchor.constraint(equalTo: postContentView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(-1)),
            anonsContentView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: UiKitFacade.shared.getConstraintContant(-2)),
//
//            likesCounterView.topAnchor.constraint(equalTo: anonsContentView.bottomAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
//            likesCounterView.leadingAnchor.constraint(equalTo: postContentView.leadingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
//            likesCounterView.bottomAnchor.constraint(equalTo: postContentView.bottomAnchor, constant:  UiKitFacade.shared.getConstraintContant(-1)),
//            likesCounterView.trailingAnchor.constraint(equalTo: likesCounterLabel.trailingAnchor),
//            likesCounterIcon.leadingAnchor.constraint(equalTo: likesCounterView.leadingAnchor),
//            likesCounterIcon.topAnchor.constraint(equalTo: likesCounterView.topAnchor),
//            likesCounterIcon.bottomAnchor.constraint(equalTo: likesCounterView.bottomAnchor),
//            likesCounterLabel.leadingAnchor.constraint(equalTo: likesCounterIcon.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
//            likesCounterLabel.topAnchor.constraint(equalTo: likesCounterView.topAnchor),
//            likesCounterLabel.bottomAnchor.constraint(equalTo: likesCounterView.bottomAnchor),
//
//            commentsCounterView.topAnchor.constraint(equalTo: likesCounterView.topAnchor),
//            commentsCounterView.leadingAnchor.constraint(equalTo: likesCounterView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
//            commentsCounterView.bottomAnchor.constraint(equalTo: likesCounterView.bottomAnchor),
//            commentsCounterView.trailingAnchor.constraint(equalTo: commentsCounterLabel.trailingAnchor),
//            commentsCounterIcon.leadingAnchor.constraint(equalTo: commentsCounterView.leadingAnchor),
//            commentsCounterIcon.topAnchor.constraint(equalTo: commentsCounterView.topAnchor),
//            commentsCounterIcon.bottomAnchor.constraint(equalTo: commentsCounterView.bottomAnchor),
//            commentsCounterLabel.leadingAnchor.constraint(equalTo: commentsCounterIcon.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)),
//            commentsCounterLabel.topAnchor.constraint(equalTo: commentsCounterView.topAnchor),
//            commentsCounterLabel.bottomAnchor.constraint(equalTo: commentsCounterView.bottomAnchor),
//
//            favoriteView.topAnchor.constraint(equalTo: commentsCounterView.topAnchor),
//            favoriteView.bottomAnchor.constraint(equalTo: commentsCounterView.bottomAnchor),
//            favoriteView.leadingAnchor.constraint(equalTo: favoriteCounterIcon.leadingAnchor),
//            favoriteView.trailingAnchor.constraint(equalTo: postContentView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(-2)),
//            favoriteCounterIcon.trailingAnchor.constraint(equalTo: favoriteView.trailingAnchor),
//            favoriteCounterIcon.topAnchor.constraint(equalTo: favoriteView.topAnchor),
//            favoriteCounterIcon.bottomAnchor.constraint(equalTo: favoriteView.bottomAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
