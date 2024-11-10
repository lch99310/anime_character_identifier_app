import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "AC Identifier"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var appDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "歡迎使用AC Identifier！\n這是一個專門用於識別動漫角色的應用程序。\n只需拍照或選擇圖片，即可快速識別動漫角色並獲取相關信息。"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var instructionsView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var instructionsLabel: UILabel = {
        let label = UILabel()
        label.text = "使用說明"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var instructionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("使用相機拍攝", for: .normal)
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIHelper.primaryColor
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("從相冊選擇", for: .normal)
        button.setImage(UIImage(systemName: "photo.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIHelper.primaryColor
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(galleryButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // 添加scrollView和contentView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加其他視圖
        contentView.addSubview(titleLabel)
        contentView.addSubview(appDescriptionLabel)
        contentView.addSubview(instructionsView)
        
        instructionsView.addSubview(instructionsLabel)
        instructionsView.addSubview(instructionsStackView)
        
        // 添加使用說明步驟
        let steps = [
            "1. 選擇使用相機拍攝或從相冊選擇圖片",
            "2. 確保圖片中包含要識別的動漫角色",
            "3. 等待系統識別完成",
            "4. 查看角色詳細信息"
        ]
        
        steps.forEach { step in
            let stepLabel = UILabel()
            stepLabel.text = step
            stepLabel.font = .systemFont(ofSize: 14)
            stepLabel.numberOfLines = 0
            instructionsStackView.addArrangedSubview(stepLabel)
        }
        
        let buttonStack = UIStackView(arrangedSubviews: [cameraButton, galleryButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 16
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            appDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            appDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            appDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            instructionsView.topAnchor.constraint(equalTo: appDescriptionLabel.bottomAnchor, constant: 30),
            instructionsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            instructionsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            instructionsLabel.topAnchor.constraint(equalTo: instructionsView.topAnchor, constant: 16),
            instructionsLabel.leadingAnchor.constraint(equalTo: instructionsView.leadingAnchor, constant: 16),
            instructionsLabel.trailingAnchor.constraint(equalTo: instructionsView.trailingAnchor, constant: -16),
            
            instructionsStackView.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 16),
            instructionsStackView.leadingAnchor.constraint(equalTo: instructionsView.leadingAnchor, constant: 16),
            instructionsStackView.trailingAnchor.constraint(equalTo: instructionsView.trailingAnchor, constant: -16),
            instructionsStackView.bottomAnchor.constraint(equalTo: instructionsView.bottomAnchor, constant: -16),
            
            buttonStack.topAnchor.constraint(equalTo: instructionsView.bottomAnchor, constant: 30),
            buttonStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            cameraButton.widthAnchor.constraint(equalToConstant: 200),
            cameraButton.heightAnchor.constraint(equalToConstant: 50),
            
            galleryButton.widthAnchor.constraint(equalToConstant: 200),
            galleryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Actions
    @objc private func cameraButtonTapped() {
        let cameraVC = CameraViewController()
        cameraVC.delegate = self
        cameraVC.modalPresentationStyle = .fullScreen
        present(cameraVC, animated: true)
    }
    
    @objc private func galleryButtonTapped() {
        let imagePickerVC = ImagePickerViewController()
        imagePickerVC.delegate = self
        imagePickerVC.modalPresentationStyle = .fullScreen
        present(imagePickerVC, animated: true)
    }
}

// MARK: - CameraViewControllerDelegate
extension WelcomeViewController: CameraViewControllerDelegate {
    func camera(_ camera: CameraViewController, didCapture image: UIImage) {
        camera.dismiss(animated: true) {
            let homeVC = HomeViewController()
            homeVC.handleSelectedImage(image)
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    func cameraDidCancel(_ camera: CameraViewController) {
        camera.dismiss(animated: true)
    }
}

// MARK: - ImagePickerViewControllerDelegate
extension WelcomeViewController: ImagePickerViewControllerDelegate {
    func imagePicker(_ picker: ImagePickerViewController, didSelect image: UIImage) {
        picker.dismiss(animated: true) {
            let homeVC = HomeViewController()
            homeVC.handleSelectedImage(image)
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    func imagePickerDidCancel(_ picker: ImagePickerViewController) {
        picker.dismiss(animated: true)
    }
} 