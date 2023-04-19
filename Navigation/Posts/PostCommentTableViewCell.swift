import UIKit

class PostCommentTableViewCell: UITableViewCell {
    var postComment: PostComment?
    /** @todo */
    var tempPostCommentsContent: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        
        contentView.addSubviews([
            tempPostCommentsContent,
        ])
        contentView.backgroundColor = UiKitFacade.shared.getSecondaryBackgroundColor()
        
        activateConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            tempPostCommentsContent.topAnchor.constraint(equalTo: contentView.topAnchor),
            tempPostCommentsContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tempPostCommentsContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tempPostCommentsContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func initFromPostComment(_ postComment: PostComment) {
        /** @todo */
        self.tempPostCommentsContent.text += "---\n"
        self.tempPostCommentsContent.text += "Blogger ID: \(postComment.blogger)\n"
        self.tempPostCommentsContent.text += "Parent: \(String(describing: postComment.parent))\n"
        self.tempPostCommentsContent.text += "commentedAt: \(postComment.commentedAt)\n"
        self.tempPostCommentsContent.text += "Comment: \(postComment.comment)\n"
    }
}
