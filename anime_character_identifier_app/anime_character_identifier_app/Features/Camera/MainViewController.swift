import UIKit

class MainViewController: UIViewController {
    private let serviceCoordinator: ServiceCoordinator
    private let processingView = ProcessingView()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Take Photo", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        return button
    }()
    
    private lazy var libraryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Choose from Library", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(chooseFromLibrary), for: .touchUpInside)
        return button
    }()
    
    init(serviceCoordinator: ServiceCoordinator = ServiceCoordinator()) {
        self.serviceCoordinator = serviceCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        let stackView = UIStackView(arrangedSubviews: [cameraButton, libraryButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            cameraButton.heightAnchor.constraint(equalToConstant: 44),
            libraryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func captureImage() {
        Task {
            do {
                let hasPermission = try await CameraManager.shared.requestPermissions()
                guard hasPermission else {
                    showPermissionAlert()
                    return
                }
                
                try CameraManager.shared.setupCamera()
                presentCamera()
            } catch {
                showError(error)
            }
        }
    }
    
    @objc private func chooseFromLibrary() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func presentCamera() {
        let cameraVC = CameraViewController { [weak self] result in
            switch result {
            case .success(let image):
                self?.processSelectedImage(image)
            case .failure(let error):
                self?.showError(error)
            }
        }
        present(cameraVC, animated: true)
    }
    
    private func processSelectedImage(_ image: UIImage) {
        processingView.startAnimating()
        
        Task {
            do {
                let (character, videos) = try await serviceCoordinator.processImage(image)
                await MainActor.run {
                    processingView.stopAnimating()
                    presentResults(character: character, videos: videos)
                }
            } catch {
                await MainActor.run {
                    processingView.stopAnimating()
                    showError(error)
                }
            }
        }
    }
    
    private func presentResults(character: CharacterDetails, videos: [VideoResult]) {
        let resultsVC = ResultsViewController(character: character, videos: videos)
        navigationController?.pushViewController(resultsVC, animated: true)
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: "Permission Required",
            message: "Please enable camera and photo library access in Settings",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    // UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            showError(CameraError.captureError)
            return
        }
        
        processSelectedImage(image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// Add protocol conformance
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // ... existing delegate methods ...
} 