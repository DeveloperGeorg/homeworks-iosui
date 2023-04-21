import UIKit

class PSOverlaySpinner: UIView {

    private var isSpinning: Bool = false

    private lazy var spinner : UIActivityIndicatorView = {
        var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.8)
        self.isSpinning = false
        self.isHidden = true
        createSubviews()
    }

    deinit {
        self.removeFromSuperview()
    }

    func createSubviews() -> Void {
        self.addSubview(spinner)
        setupAutoLayout()
    }

    private func setupAutoLayout() {
        if #available(iOS 11.0, *) {
            spinner.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
            spinner.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }

    public func show() -> Void {
        DispatchQueue.main.async {
            if !self.spinner.isAnimating {
                self.spinner.startAnimating()
            }
            self.isHidden = false
        }
        isSpinning = true
    }

    public func hide() -> Void {
        DispatchQueue.main.async {
            if self.spinner.isAnimating {
                self.spinner.stopAnimating()
            }
            self.isHidden = true
        }
        isSpinning = false
    }
}
