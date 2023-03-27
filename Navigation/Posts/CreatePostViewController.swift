import UIKit
import Uploadcare

class CreatePostViewController: UIViewController {
    private let postItemDataStorage: PostItemDataStorageProtocol
    private let fileUploader: FileUploaderProtocol

    init() {
        self.postItemDataStorage = FirestorePostItemDataStorage()
        self.fileUploader = UploadcareFileUploader()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create new post"
        view.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        self.fileUploader.uploadFile() {fileName, errorMessage in
            DispatchQueue.main.async {
                print("filename: \(fileName)")
                if let fileName = fileName {
                    print("start creating post")
                    let post = PostItem(
                        blogger: "TIQqWZVxbn03MRxsioz6",
                        mainImageLink: fileName,
                        content: "generated content \(UUID.init().uuidString)"
                    )
                    self.postItemDataStorage.create(post) { posts, hasMore in
                        print("post item")
                    }
                }
            }
        }
    }

}
