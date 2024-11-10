import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let loadingView = LoadingView()
    private var session: AVCaptureSession?
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "AC Identifier"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var previewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIHelper.secondaryColor
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "選擇或拍攝一張動漫角色圖片"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("拍照", for: .normal)
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
        Logger.shared.info("HomeViewController loaded")
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // 設置背景色
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        // 添加子視圖
        view.addSubview(titleLabel)
        view.addSubview(previewContainer)
        previewContainer.addSubview(previewImageView)
        previewContainer.addSubview(placeholderLabel)
        
        // 創建按鈕堆疊視圖
        let buttonStack = UIStackView(arrangedSubviews: [cameraButton, galleryButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 16
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)
        
        // 設置約束
        NSLayoutConstraint.activate([
            // 標題標籤約束
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 預覽容器約束
            previewContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            previewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            previewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            previewContainer.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            // 預覽圖片視圖約束
            previewImageView.topAnchor.constraint(equalTo: previewContainer.topAnchor),
            previewImageView.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: previewContainer.trailingAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: previewContainer.bottomAnchor),
            
            // 佔位符標籤約束
            placeholderLabel.centerXAnchor.constraint(equalTo: previewContainer.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: previewContainer.centerYAnchor),
            
            // 按鈕堆疊視圖約束
            buttonStack.topAnchor.constraint(equalTo: previewContainer.bottomAnchor, constant: 30),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // 按鈕尺寸約束
            cameraButton.widthAnchor.constraint(equalToConstant: 200),
            cameraButton.heightAnchor.constraint(equalToConstant: 50),
            
            galleryButton.widthAnchor.constraint(equalToConstant: 200),
            galleryButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        Logger.shared.info("UI setup completed")
    }
    
    // MARK: - Camera Permission
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            print("相機權限未確定，請求權限")
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .restricted, .denied:
            print("相機權限被拒絕")
            DispatchQueue.main.async {
                self.showCameraPermissionAlert()
                completion(false)
            }
        case .authorized:
            print("已有相機權限")
            completion(true)
        @unknown default:
            completion(false)
        }
    }
    
    private func showCameraPermissionAlert() {
        let alert = UIAlertController(
            title: "需要相機權限",
            message: "請在設置中開啟相機權限以使用此功能",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "去設置", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func cameraButtonTapped() {
        print("相機按鈕被點擊")
        checkCameraPermission { [weak self] granted in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if granted {
                    print("相機權限已獲得，打開相機")
                    let cameraVC = CameraViewController()
                    cameraVC.delegate = self
                    cameraVC.modalPresentationStyle = .fullScreen
                    self.present(cameraVC, animated: true)
                }
            }
        }
    }
    
    @objc private func galleryButtonTapped() {
        print("相冊按鈕被點擊")
        let imagePickerVC = ImagePickerViewController()
        imagePickerVC.delegate = self
        imagePickerVC.modalPresentationStyle = .fullScreen
        present(imagePickerVC, animated: true)
    }
    
    // MARK: - Image Processing
    func handleSelectedImage(_ image: UIImage) {
        print("��理選擇的圖片")
        previewImageView.image = image
        placeholderLabel.isHidden = true
        processSelectedImage(image)
    }
    
    private var lastProcessedImage: UIImage?
    
    private func processSelectedImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.previewImageView.image = image
            self.placeholderLabel.isHidden = true
            self.loadingView.show(in: self.view, message: "正在識別角色...")
        }
        
        // 步驟1: 使用Llama識別角色
        LlamaService.shared.identifyCharacter(from: image) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let llamaResponse):
                print("Llama識別結果：\(llamaResponse)")
                let cleanedName = llamaResponse
                    .replacingOccurrences(of: "Character:", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                // 步驟2: 使用ACDB搜索角色詳細信息
                self.searchCharacterInACDB(cleanedName)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.loadingView.hide()
                    ErrorHandler.showError(error, in: self)
                }
            }
        }
    }
    
    private func searchCharacterInACDB(_ characterName: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingView.show(in: self.view, message: "搜索角色信息...")
        }
        
        print("使用 \(characterName) 在ACDB中搜索")
        
        AnimeDBService.shared.searchCharacter(name: characterName) { [weak self] (result: Result<[Models.ACDBCharacter], Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loadingView.hide()
                
                switch result {
                case .success(let characters):
                    if let character = characters.first {
                        print("找到角色：\(character.name)")
                        let detailVC = CharacterDetailViewController(character: character)
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    } else {
                        ErrorHandler.showError(AppError.characterNotFound, in: self)
                    }
                    
                case .failure(let error):
                    ErrorHandler.showError(error, in: self)
                }
            }
        }
    }
    
    func retryLastOperation() {
        if let image = lastProcessedImage {
            processSelectedImage(image)
        }
    }
    
    func retryImageProcessing() {
        if let image = lastProcessedImage {
            processSelectedImage(image)
        }
    }
}

// MARK: - Camera Delegate
extension HomeViewController: CameraViewControllerDelegate {
    func camera(_ camera: CameraViewController, didCapture image: UIImage) {
        print("相機拍攝完成")
        camera.dismiss(animated: true) { [weak self] in
            self?.handleSelectedImage(image)
        }
    }
    
    func cameraDidCancel(_ camera: CameraViewController) {
        print("取消相機")
        camera.dismiss(animated: true)
    }
}

// MARK: - Image Picker Delegate
extension HomeViewController: ImagePickerViewControllerDelegate {
    func imagePicker(_ picker: ImagePickerViewController, didSelect image: UIImage) {
        print("選擇圖片完成")
        picker.dismiss(animated: true) { [weak self] in
            self?.handleSelectedImage(image)
        }
    }
    
    func imagePickerDidCancel(_ picker: ImagePickerViewController) {
        print("取消選擇圖片")
        picker.dismiss(animated: true)
    }
}