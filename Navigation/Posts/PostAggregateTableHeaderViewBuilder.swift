import UIKit

class PostAggregateTableHeaderViewBuilder {
    static let headerHeight = CGFloat(590)
    
    static func build(
        _ post: PostAggregate,
        likeTapGesture: UITapGestureRecognizer,
        favoriteTapGesture: UITapGestureRecognizer
    ) -> UIView {
        let view = UIView()
        view.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        var authorContentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
            
           return view
        }()
        var authorTitleLabel: UILabel = {
            let label = UILabel()
            label.textColor = UiKitFacade.shared.getPrimaryTextColor()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UiKitFacade.shared.getSecondaryTitleFont()
            
            return label
        }()
        authorTitleLabel.text = post.blogger.name
        var authorSubTitleLabel: UILabel = {
            let label = UILabel()
            label.textColor = UiKitFacade.shared.getSecondaryTextColor()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UiKitFacade.shared.getTertiaryTitleFont()

            return label
        }()
        authorSubTitleLabel.text = post.blogger.shortDescription
        var authorImageBlockView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
    
           return view
        }()
        var authorImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 25 /** @todo dynamic corner radius */
    
            return imageView
        }()
        let imageService: ImageService = ImageService()
        imageService.getUIImageByUrlString(post.blogger.imageLink) { uiImage in
            authorImageView.image = uiImage
        }
        authorImageBlockView.addSubviews([authorImageView])
        authorContentView.addSubviews([
            authorImageBlockView,
            authorTitleLabel,
            authorSubTitleLabel
        ])
        
        var postContentView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
            
           return view
        }()
        var mainImageBlockView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
           return view
        }()
        var mainImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            /** @todo corner radius */
            return imageView
        }()
        imageService.getUIImageByUrlString(post.post.mainImageLink) { uiImage in
            mainImageView.image = uiImage
        }
        mainImageBlockView.addSubviews([mainImageView])
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
        anonsContentView.text = post.post.content
        
        var likesCounterView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.isExclusiveTouch = true
            
           return view
        }()
        likesCounterView.addGestureRecognizer(likeTapGesture)
        var likesCounterIcon: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "like-heart")!
            
            return imageView
        }()
        if post.isLiked {
            if let likeImage = likesCounterIcon.image?.maskWithColor(color: UiKitFacade.shared.getAccentColor()) {
                likesCounterIcon.image = likeImage
            }
        }
        var likesCounterLabel: UILabel = {
            let label = UILabel()
            label.textColor = UiKitFacade.shared.getPrimaryTextColor()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UiKitFacade.shared.getRegularTextFont()
            
            return label
        }()
        likesCounterLabel.text = "\(post.likesAmount)"
        likesCounterView.addSubviews([
            likesCounterIcon,
            likesCounterLabel
        ])
        
        var commentsCounterView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
           return view
        }()
        var commentsCounterIcon: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "speech-bubble")!
            return imageView
        }()
        var commentsCounterLabel: UILabel = {
            let label = UILabel()
            label.textColor = UiKitFacade.shared.getPrimaryTextColor()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UiKitFacade.shared.getRegularTextFont()
            
            return label
        }()
        commentsCounterLabel.text = "\(post.commentsAmount)"
        commentsCounterView.addSubviews([
            commentsCounterIcon,
            commentsCounterLabel
        ])
        
        var favoriteView: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.isExclusiveTouch = true
            
           return view
        }()
        favoriteView.addGestureRecognizer(favoriteTapGesture)
        var favoriteCounterIcon: UIImageView = {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "favorite")!
            return imageView
        }()
        if post.isFavorite {
            if let favoriteImage = favoriteCounterIcon.image?.maskWithColor(color: UiKitFacade.shared.getAccentColor()) {
                favoriteCounterIcon.image = favoriteImage
            }
        }
        favoriteView.addSubviews([favoriteCounterIcon])
        
        postContentView.addSubviews([
            mainImageBlockView,
            anonsContentView,
            likesCounterView,
            commentsCounterView,
            favoriteView
        ])
        
        view.addSubviews([
            authorContentView,
            postContentView
        ])
        
        authorContentView.topAnchor.constraint(equalTo: view.topAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)).isActive = true
        authorContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)).isActive = true
        authorContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(-1)).isActive = true
        authorContentView.bottomAnchor.constraint(equalTo: authorImageBlockView.bottomAnchor).isActive = true
        
        let maxImageHeight = CGFloat(200)
        let maxAvatarSize = CGFloat(50)
        authorImageBlockView.topAnchor.constraint(equalTo: authorContentView.topAnchor).isActive = true
        authorImageBlockView.leadingAnchor.constraint(equalTo: authorContentView.leadingAnchor).isActive = true
        authorImageBlockView.trailingAnchor.constraint(equalTo: authorImageView.trailingAnchor).isActive = true
        authorImageView.heightAnchor.constraint(equalToConstant: maxAvatarSize).isActive = true
        authorImageView.widthAnchor.constraint(equalToConstant: maxAvatarSize).isActive = true
        authorImageView.topAnchor.constraint(equalTo: authorImageBlockView.topAnchor).isActive = true
        authorImageView.leadingAnchor.constraint(equalTo: authorImageBlockView.leadingAnchor).isActive = true
        authorImageView.bottomAnchor.constraint(equalTo: authorImageBlockView.bottomAnchor).isActive = true
        
        authorTitleLabel.topAnchor.constraint(equalTo: authorContentView.topAnchor).isActive = true
        authorTitleLabel.leadingAnchor.constraint(equalTo: authorImageBlockView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)).isActive = true
        authorTitleLabel.trailingAnchor.constraint(equalTo: authorContentView.trailingAnchor).isActive = true
        authorSubTitleLabel.topAnchor.constraint(equalTo: authorTitleLabel.bottomAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)).isActive = true
        authorSubTitleLabel.leadingAnchor.constraint(equalTo: authorImageBlockView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)).isActive = true
        authorSubTitleLabel.trailingAnchor.constraint(equalTo: authorContentView.trailingAnchor).isActive = true
        
        postContentView.topAnchor.constraint(equalTo: authorContentView.bottomAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)).isActive = true
        postContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)).isActive = true
        postContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(-1)).isActive = true
        postContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainImageBlockView.topAnchor.constraint(equalTo: postContentView.topAnchor).isActive = true
        mainImageBlockView.leadingAnchor.constraint(equalTo: postContentView.leadingAnchor).isActive = true
        mainImageBlockView.trailingAnchor.constraint(equalTo: postContentView.trailingAnchor).isActive = true
        mainImageBlockView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor).isActive = true
        mainImageView.centerXAnchor.constraint(equalTo: mainImageBlockView.centerXAnchor).isActive = true
        mainImageView.centerYAnchor.constraint(equalTo: mainImageBlockView.centerYAnchor).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: maxImageHeight).isActive = true
        anonsContentView.topAnchor.constraint(equalTo: mainImageBlockView.bottomAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)).isActive = true
        anonsContentView.leadingAnchor.constraint(equalTo: postContentView.leadingAnchor).isActive = true
        anonsContentView.trailingAnchor.constraint(equalTo: postContentView.trailingAnchor).isActive = true
//        anonsContentView.bottomAnchor.constraint(equalTo: postContentView.bottomAnchor).isActive = true
        likesCounterView.topAnchor.constraint(equalTo: anonsContentView.bottomAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)).isActive = true
        likesCounterView.leadingAnchor.constraint(equalTo: postContentView.leadingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)).isActive = true
        likesCounterView.bottomAnchor.constraint(equalTo: postContentView.bottomAnchor, constant:  UiKitFacade.shared.getConstraintContant(-1)).isActive = true
        likesCounterView.trailingAnchor.constraint(equalTo: likesCounterLabel.trailingAnchor).isActive = true
        likesCounterIcon.leadingAnchor.constraint(equalTo: likesCounterView.leadingAnchor).isActive = true
        likesCounterIcon.topAnchor.constraint(equalTo: likesCounterView.topAnchor).isActive = true
        likesCounterIcon.bottomAnchor.constraint(equalTo: likesCounterView.bottomAnchor).isActive = true
        likesCounterLabel.leadingAnchor.constraint(equalTo: likesCounterIcon.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)).isActive = true
        likesCounterLabel.topAnchor.constraint(equalTo: likesCounterView.topAnchor).isActive = true
        likesCounterLabel.bottomAnchor.constraint(equalTo: likesCounterView.bottomAnchor).isActive = true
        commentsCounterView.topAnchor.constraint(equalTo: likesCounterView.topAnchor).isActive = true
        commentsCounterView.leadingAnchor.constraint(equalTo: likesCounterView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)).isActive = true
        commentsCounterView.bottomAnchor.constraint(equalTo: likesCounterView.bottomAnchor).isActive = true
        commentsCounterView.trailingAnchor.constraint(equalTo: commentsCounterLabel.trailingAnchor).isActive = true
        commentsCounterIcon.leadingAnchor.constraint(equalTo: commentsCounterView.leadingAnchor).isActive = true
        commentsCounterIcon.topAnchor.constraint(equalTo: commentsCounterView.topAnchor).isActive = true
        commentsCounterIcon.bottomAnchor.constraint(equalTo: commentsCounterView.bottomAnchor).isActive = true
        commentsCounterLabel.leadingAnchor.constraint(equalTo: commentsCounterIcon.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(1)).isActive = true
        commentsCounterLabel.topAnchor.constraint(equalTo: commentsCounterView.topAnchor).isActive = true
        commentsCounterLabel.bottomAnchor.constraint(equalTo: commentsCounterView.bottomAnchor).isActive = true
        favoriteView.topAnchor.constraint(equalTo: commentsCounterView.topAnchor).isActive = true
        favoriteView.bottomAnchor.constraint(equalTo: commentsCounterView.bottomAnchor).isActive = true
        favoriteView.leadingAnchor.constraint(equalTo: favoriteCounterIcon.leadingAnchor).isActive = true
        favoriteView.trailingAnchor.constraint(equalTo: postContentView.trailingAnchor, constant:  UiKitFacade.shared.getConstraintContant(-2)).isActive = true
        favoriteCounterIcon.trailingAnchor.constraint(equalTo: favoriteView.trailingAnchor).isActive = true
        favoriteCounterIcon.topAnchor.constraint(equalTo: favoriteView.topAnchor).isActive = true
        favoriteCounterIcon.bottomAnchor.constraint(equalTo: favoriteView.bottomAnchor).isActive = true
        
        return view
    }
}
