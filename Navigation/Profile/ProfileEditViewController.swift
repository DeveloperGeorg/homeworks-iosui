import UIKit

class ProfileEditViewController: UIViewController {
    var user: User
    var blogger: BloggerPreview? = nil
    private let userService: UserService
    private let bloggerDataProvider: BloggerDataProviderProtocol
    
    var shortDescriptionTextInput: CustomTextInput = {
        let shortDescriptionTextInput = CustomTextInput()
        shortDescriptionTextInput.placeholder = String(localized: "Short description")
        shortDescriptionTextInput.label.text = "Short description"
        
        return shortDescriptionTextInput
    }()
    
    init(user: User, userService: UserService) {
        self.user = user
        self.userService = userService
        self.bloggerDataProvider = FirestoreBloggerDataProvider()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = String(localized: "Profile edit")
        view.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        
        initViewAndActivateConstraints()
        
        bloggerDataProvider.getByUserId(self.user.userId) { blogger in
            if let blogger = blogger {
                self.blogger = blogger
                self.shortDescriptionTextInput.text = self.blogger?.shortDescription
            }
        }
        
        print(user.userId)
        // Do any additional setup after loading the view.
    }
    
    func initViewAndActivateConstraints() {
        view.addSubviews([
            shortDescriptionTextInput
        ])
        NSLayoutConstraint.activate([
            shortDescriptionTextInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            shortDescriptionTextInput.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            shortDescriptionTextInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            shortDescriptionTextInput.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
