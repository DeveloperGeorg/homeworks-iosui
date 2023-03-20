import UIKit
import StorageService

class DebugPostDataProvider: PostDataProviderProtocol {
    func getList() -> [StorageService.Post] {
        return [
            {
                return Post(author: String(format: String(localized: "test"), arguments: ["1"]), description: String(format: String(localized: "amaizing_description"), arguments: ["1"]), image: UIImage(named: "post1.jpg")!, likes: 10, views: 25)
            }(),
            {
                return Post(
                    author: "Test2. Changing you mind. You will never forget! I'll promise. This is extraordinarily long author name",
                    description: "Amaizing description 2. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    image: UIImage(named: "post2.jpg")!,
                    likes: 201,
                    views: 235
                )
            }(),
            {
                return Post(author: String(format: String(localized: "test"), arguments: ["3"]), description: String(format: String(localized: "amaizing_description"), arguments: ["3"]), image: UIImage(named: "post3.jpg")!, likes: 30, views: 75)
            }(),
            {
                return Post(author: String(format: String(localized: "test"), arguments: ["4"]), description: String(format: String(localized: "amaizing_description"), arguments: ["4"]), image: UIImage(named: "post1.jpg")!, likes: 25, views: 59)
            }(),
            {
                return Post(author: String(format: String(localized: "test"), arguments: ["2"]), description: String(format: String(localized: "amaizing_description"), arguments: ["5"]), image: UIImage(named: "post1.jpg")!, likes: 35, views: 338)
            }(),
        ]
    }
    
    
}
