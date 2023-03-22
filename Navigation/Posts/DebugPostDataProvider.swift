import UIKit

class DebugPostDataProvider: PostDataProviderProtocol {
    func getList(completionHandler: @escaping ([PostItem]) -> Void) {
        completionHandler([
            {
                return PostItem(
                    author: BloggerPreview(
                        id: 1,
                        name: "Blogger One",
                        imageLink: "cat-avatar.png",
                        shortDescription: "Designer"
                    ),
                    mainImageLink: "post1.jpg",
                    content: "Amaizing description 1.",
                    likesAmount: 10,
                    commentsAmount: 5
                )
            }(),
            {
                return PostItem(
                    author: BloggerPreview(
                        id: 1,
                        name: "Blogger Two",
                        imageLink: "cat-avatar.png",
                        shortDescription: "QA"
                    ),
                    mainImageLink: "post1.jpg",
                    content: "Amaizing description 2. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    likesAmount: 7,
                    commentsAmount: 4
                )
            }(),
            {
                return PostItem(
                    author: BloggerPreview(
                        id: 2,
                        name: "Blogger One",
                        imageLink: "cat-avatar.png"
                    ),
                    mainImageLink: "post1.jpg",
                    content: "Amaizing description 3. Some content",
                    likesAmount: 3,
                    commentsAmount: 1
                )
            }(),
        ])
    }
    
    
}
