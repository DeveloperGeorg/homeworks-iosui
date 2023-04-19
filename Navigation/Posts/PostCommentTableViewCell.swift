import UIKit

class PostCommentTableViewCell: UITableViewCell {
    var postComment: PostCommentAggregate?
    private let imageService: ImageService = ImageService()
    private let textCutter: TextCutter = TextCutter()
    let dateFormatter = DateFormatter()
    fileprivate let maxAvatarSize = CGFloat(50)
    var authorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25 /** @todo dynamic corner radius */
        
        return imageView
    }()
    var authorTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UiKitFacade.shared.getPrimaryTextColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UiKitFacade.shared.getSecondaryTitleFont()
        
        return label
    }()
    var commentText: UILabel = {
        let label = UILabel()
        label.textColor = UiKitFacade.shared.getPrimaryTextColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UiKitFacade.shared.getSecondaryTitleFont()
        
        return label
    }()
    var commentedAt: UILabel = {
        let label = UILabel()
        label.textColor = UiKitFacade.shared.getPrimaryTextColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UiKitFacade.shared.getSecondaryTitleFont()
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        
        authorTitleLabel.font = UiKitFacade.shared.getQuaternaryTitleFont()
        authorTitleLabel.textColor = UiKitFacade.shared.getAccentColor()
        commentText.font = UiKitFacade.shared.getSmallTextFont()
        commentText.textColor = UiKitFacade.shared.getPrimaryTextColor()
        commentedAt.font = UiKitFacade.shared.getSmallTextFont()
        commentedAt.textColor = UiKitFacade.shared.getSecondaryTextColor()
        
        contentView.addSubviews([
            authorImageView,
            authorTitleLabel,
            commentText,
            commentedAt,
        ])
        contentView.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        
        activateConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            authorImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UiKitFacade.shared.getConstraintContant(1)),
            authorImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UiKitFacade.shared.getConstraintContant(1)),
            authorImageView.heightAnchor.constraint(equalToConstant: maxAvatarSize),
            authorImageView.widthAnchor.constraint(equalToConstant: maxAvatarSize),
            
            authorTitleLabel.topAnchor.constraint(equalTo: authorImageView.topAnchor),
            authorTitleLabel.leadingAnchor.constraint(equalTo: authorImageView.trailingAnchor, constant: UiKitFacade.shared.getConstraintContant(1)),
            authorTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UiKitFacade.shared.getConstraintContant(-1)),
            
            commentText.topAnchor.constraint(equalTo: authorTitleLabel.bottomAnchor, constant: UiKitFacade.shared.getConstraintContant(1)),
            commentText.leadingAnchor.constraint(equalTo: authorTitleLabel.leadingAnchor),
            commentText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UiKitFacade.shared.getConstraintContant(-1)),
            
            commentedAt.topAnchor.constraint(equalTo: commentText.bottomAnchor, constant: UiKitFacade.shared.getConstraintContant(1)),
            commentedAt.leadingAnchor.constraint(equalTo: commentText.leadingAnchor),
            commentedAt.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UiKitFacade.shared.getConstraintContant(-1)),
            commentedAt.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: UiKitFacade.shared.getConstraintContant(-1)),
        ])
    }
    
    func initFromPostComment(_ postComment: PostCommentAggregate) {
        self.imageService.getUIImageByUrlString(postComment.blogger.imageLink) { uiImage in
            self.authorImageView.image = uiImage
        }
        authorTitleLabel.text = postComment.blogger.name
        commentText.text = postComment.postComment.comment
        commentedAt.text = dateFormatter.string(from: postComment.postComment.commentedAt)
    }
}
