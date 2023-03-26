import UIKit

class CreatePostViewController: UIViewController {
    private let postItemDataStorage: PostItemDataStorageProtocol

    init() {
        self.postItemDataStorage = FirestorePostItemDataStorage()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create new post"
        view.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        let post = PostItem(
            blogger: "TIQqWZVxbn03MRxsioz6",
            mainImageLink: "https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png",
            content: "generated content \(UUID.init().uuidString)"
        )
        self.postItemDataStorage.create(post) { posts, hasMore in
            print("post item")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
