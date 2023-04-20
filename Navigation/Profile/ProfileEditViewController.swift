import UIKit

class ProfileEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var user: User
    var blogger: BloggerPreview? = nil
    private let bloggerDataProvider: BloggerDataProviderProtocol
    private let bloggerDataStorage: BloggerDataStorageProtocol
    private let coordinator: ProfileCoordinator
    private let fileUploader: FileUploaderProtocol
    private let imageService: ImageService = ImageService()
    
    let imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.isEditing = true
        
        return imagePickerController
    }()
    
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
    
    var nameTextInput: CustomTextInputWithLabel = {
        let textInput = CustomTextInputWithLabel()
        textInput.placeholder = String(localized: "Name")
        textInput.label.text = String(localized: "Name")
        
        return textInput
    }()
    var shortDescriptionTextInput: CustomTextInputWithLabel = {
        let textInput = CustomTextInputWithLabel()
        textInput.placeholder = String(localized: "Short description")
        textInput.label.text = String(localized: "Short description")
        
        return textInput
    }()
    var updateBloggerButton: CustomButton = {
        let button = CustomButton(
            title: String(localized: "Update blogger info"),
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
    public lazy var spinnerView : PSOverlaySpinner = {
        let loadingView : PSOverlaySpinner = PSOverlaySpinner()
        return loadingView
    }()
    
    init(user: User, coordinator: ProfileCoordinator) {
        self.user = user
        self.coordinator = coordinator
        self.bloggerDataProvider = FirestoreBloggerDataProvider()
        self.bloggerDataStorage = FirestoreBloggerDataStorage()
        self.fileUploader = UploadcareFileUploader(
            withPublicKey: Config.shared.getValueByKey("UPLOADCARE_PUBLIC_KEY") ?? "",
            secretKey: Config.shared.getValueByKey("UPLOADCARE_SECRET_KEY") ?? ""
        )
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
        
        imagePickerController.delegate = self
        choosePictureButton.setButtonTappedCallback({ sender in
            self.present(self.imagePickerController, animated: true)
        })
        initViewAndActivateConstraints()
        
        bloggerDataProvider.getByUserId(self.user.userId) { blogger in
            if let blogger = blogger {
                self.blogger = blogger
                self.shortDescriptionTextInput.text = self.blogger?.shortDescription
                self.nameTextInput.text = self.blogger?.name
            }
        }
        updateBloggerButton.setButtonTappedCallback({ sender in
            self.spinnerView.show()
            self.blogger?.name = self.nameTextInput.text ?? (self.blogger?.name ?? "")
            self.blogger?.shortDescription = self.shortDescriptionTextInput.text ?? (self.blogger?.shortDescription ?? "")
            if let blogger = self.blogger {
                self.bloggerDataStorage.update(blogger) { wasUpdated in
                    self.spinnerView.hide()
                    if !wasUpdated {
                        self.coordinator.showError(
                            title: String(localized: "Something went wrong"),
                            message: String(localized: "Try again later")
                        )
                    }
                }
            } else {
                self.spinnerView.hide()
                self.coordinator.showError(
                    title: String(localized: "Something went wrong"),
                    message: String(localized: "No blogger was found")
                )
            }
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var increasedMaxSizeError = false
        var fileSize = 0
        if let pickedImage = info[.originalImage] as? UIImage {

            if let data = pickedImage.pngData() {
                fileSize = data.count
                if (fileSize <= self.fileUploader.getMaxFileSize()) {
                    self.spinnerView.show()
                    self.fileUploader.uploadFile(data) {fileName, errorMessage in
                        DispatchQueue.main.async {
                            if let fileName = fileName {
                                self.blogger?.imageLink = fileName
                                if let blogger = self.blogger {
                                    self.bloggerDataStorage.update(blogger) { wasUpdated in
                                        self.spinnerView.hide()
                                        if wasUpdated {
                                            self.imageService.getUIImageByUrlString(fileName) { uiImage in
                                                print("file \(fileName) was cached")
                                            }
                                        } else {
                                            self.coordinator.showError(
                                                title: String(localized: "Something went wrong"),
                                                message: String(localized: "Try again later")
                                            )
                                        }
                                    }
                                } else {
                                    self.spinnerView.hide()
                                    self.coordinator.showError(
                                        title: String(localized: "Something went wrong"),
                                        message: String(localized: "No blogger was found")
                                    )
                                }
                            } else {
                                self.spinnerView.hide()
                            }
                        }
                    }
                } else {
                    increasedMaxSizeError = true
                }
            }
        }
        dismiss(animated: true)
        if increasedMaxSizeError {
            self.coordinator.showError(
                title: String(localized: "Error max file size"),
                message: String(localized: "You trying to load image with size \(fileSize). Max file size is \(self.fileUploader.getMaxFileSize()). Please, choose other image")
            )
        }
    }
    
    func initViewAndActivateConstraints() {
        view.addSubviews([
            choosePictureButton,
            nameTextInput,
            shortDescriptionTextInput,
            updateBloggerButton
        ])
        view.addSubview(spinnerView)
        NSLayoutConstraint.activate([
            choosePictureButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            choosePictureButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            choosePictureButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            choosePictureButton.heightAnchor.constraint(equalToConstant: 100),
            nameTextInput.topAnchor.constraint(equalTo: choosePictureButton.bottomAnchor, constant: 32),
            nameTextInput.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            nameTextInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            nameTextInput.heightAnchor.constraint(equalToConstant: 40),
            shortDescriptionTextInput.topAnchor.constraint(equalTo: nameTextInput.bottomAnchor, constant: 32),
            shortDescriptionTextInput.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            shortDescriptionTextInput.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            shortDescriptionTextInput.heightAnchor.constraint(equalToConstant: 40),
            updateBloggerButton.topAnchor.constraint(equalTo: shortDescriptionTextInput.bottomAnchor, constant: 8),
            updateBloggerButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            updateBloggerButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            updateBloggerButton.heightAnchor.constraint(equalToConstant: 40),
            
            spinnerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spinnerView.topAnchor.constraint(equalTo: view.topAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
