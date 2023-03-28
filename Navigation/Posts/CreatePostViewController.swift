import UIKit
import Uploadcare

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let postItemFormCoordinator: PostItemFormCoordinator
    private let postItemDataStorage: PostItemDataStorageProtocol
    private let fileUploader: FileUploaderProtocol
    
    let imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.isEditing = true
        
        return imagePickerController
    }()
    
    var fileDataToUpload: Data? = nil
    
    var choosePictureButton: CustomButton = {
        let button = CustomButton(
            title: String(localized: "Choose picture"),
            titleColor: UiKitFacade.shared.getPrimaryTextColor(),
            titleFor: .normal,
            buttonTappedCallback: nil
        )
        button.layer.cornerRadius = 4
        button.backgroundColor = UiKitFacade.shared.getAccentColor()
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = UiKitFacade.shared.getAccentColor().cgColor
        button.layer.shadowRadius = CGFloat(4)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var contentTextField: UITextView = {
        let textField = UITextView()
        textField.isEditable = true
        textField.isScrollEnabled = true
        textField.backgroundColor = UiKitFacade.shared.getSecondaryBackgroundColor()
        textField.layer.cornerRadius = 12
        textField.font = UiKitFacade.shared.getRegularTextFont()
        textField.textColor = UiKitFacade.shared.getPrimaryTextColor()
        textField.layer.borderColor = UiKitFacade.shared.getAccentColor().cgColor
        textField.layer.borderWidth = 1
        
//        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
//        textField.leftView = paddingView
//        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    var createPostButton: CustomButton = {
        let button = CustomButton(
            title: String(localized: "Create the post"),
            titleColor: UiKitFacade.shared.getPrimaryTextColor(),
            titleFor: .normal,
            buttonTappedCallback: nil
        )
        button.layer.cornerRadius = 4
        button.backgroundColor = UiKitFacade.shared.getAccentColor()
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = UiKitFacade.shared.getAccentColor().cgColor
        button.layer.shadowRadius = CGFloat(4)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    init(postItemFormCoordinator: PostItemFormCoordinator) {
        self.postItemDataStorage = FirestorePostItemDataStorage()
        self.fileUploader = UploadcareFileUploader(
            withPublicKey: Config.shared.getValueByKey("UPLOADCARE_PUBLIC_KEY") ?? "",
            secretKey: Config.shared.getValueByKey("UPLOADCARE_SECRET_KEY") ?? ""
        )
        self.postItemFormCoordinator = postItemFormCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        
        self.title = String(localized: "Create new post")
        view.backgroundColor = UiKitFacade.shared.getPrimaryBackgroundColor()
        view.addSubview(choosePictureButton)
        view.addSubview(contentTextField)
        view.addSubview(createPostButton)
        initConstraints()
        choosePictureButton.setButtonTappedCallback({ sender in
            self.present(self.imagePickerController, animated: true)
        })
        createPostButton.setButtonTappedCallback({sender in
            let content = self.contentTextField.text ?? ""
            if let fileDataToUpload = self.fileDataToUpload {
                self.fileUploader.uploadFile(fileDataToUpload) {fileName, errorMessage in
                    DispatchQueue.main.async {
                        if let fileName = fileName {
                            let post = PostItem(
                                blogger: "TIQqWZVxbn03MRxsioz6",
                                mainImageLink: fileName,
                                content: content
                            )
                            self.postItemDataStorage.create(post) { post in
                                print("post item was created")
                                self.postItemFormCoordinator.goBack()
                            }
                        }
                    }
                }
            }
        })
    }

    private func initConstraints() {
        NSLayoutConstraint.activate([
            choosePictureButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            choosePictureButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            choosePictureButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            choosePictureButton.heightAnchor.constraint(equalToConstant: 200),
            contentTextField.topAnchor.constraint(equalTo: choosePictureButton.bottomAnchor, constant: 8),
            contentTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            contentTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            contentTextField.heightAnchor.constraint(equalToConstant: 200),
            createPostButton.topAnchor.constraint(equalTo: contentTextField.bottomAnchor, constant: 8),
            createPostButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            createPostButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            createPostButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {

            if let data = pickedImage.pngData() {
                do {
                    print("Chose pictire")
                    self.fileDataToUpload = data
                } catch {
                    print("Unable to Write Image Data to Disk")
                }
            }
        }
        dismiss(animated: true)
    }
}
