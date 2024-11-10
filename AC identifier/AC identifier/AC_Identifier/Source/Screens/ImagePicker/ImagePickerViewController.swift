import UIKit
import PhotosUI

protocol ImagePickerViewControllerDelegate: AnyObject {
    func imagePicker(_ picker: ImagePickerViewController, didSelect image: UIImage)
    func imagePickerDidCancel(_ picker: ImagePickerViewController)
}

class ImagePickerViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: ImagePickerViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presentPicker()
    }
    
    // MARK: - Private Methods
    private func presentPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension ImagePickerViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else {
            delegate?.imagePickerDidCancel(self)
            return
        }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self = self,
                  let image = object as? UIImage else {
                DispatchQueue.main.async {
                    self?.delegate?.imagePickerDidCancel(self!)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.delegate?.imagePicker(self, didSelect: image)
            }
        }
    }
} 