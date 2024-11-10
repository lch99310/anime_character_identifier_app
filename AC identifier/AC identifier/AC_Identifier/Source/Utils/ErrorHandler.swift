import UIKit

class ErrorHandler {
    static func showError(_ error: Error, in viewController: UIViewController) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "錯誤",
                message: self.getErrorMessage(from: error),
                preferredStyle: .alert
            )
            
            if self.shouldShowRetryButton(for: error) {
                alert.addAction(UIAlertAction(title: "重試", style: .default) { _ in
                    self.handleRetry(for: error, in: viewController)
                })
            }
            
            if self.shouldShowSettingsButton(for: error) {
                alert.addAction(UIAlertAction(title: "前往設置", style: .default) { _ in
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                })
            }
            
            alert.addAction(UIAlertAction(title: "確定", style: .cancel))
            
            viewController.present(alert, animated: true)
        }
    }
    
    private static func getErrorMessage(from error: Error) -> String {
        if let appError = error as? AppError {
            let description = appError.errorDescription ?? "未知錯誤"
            if let suggestion = appError.recoverySuggestion {
                return "\(description)\n\n\(suggestion)"
            }
            return description
        }
        return error.localizedDescription
    }
    
    private static func shouldShowRetryButton(for error: Error) -> Bool {
        guard let appError = error as? AppError else { return false }
        switch appError {
        case .networkError, .serverError, .imageProcessingFailed,
             .characterNotFound, .quotaExceeded:
            return true
        default:
            return false
        }
    }
    
    private static func shouldShowSettingsButton(for error: Error) -> Bool {
        guard let appError = error as? AppError else { return false }
        switch appError {
        case .cameraAccessDenied, .photoLibraryAccessDenied:
            return true
        default:
            return false
        }
    }
    
    private static func handleRetry(for error: Error, in viewController: UIViewController) {
        if let homeVC = viewController as? HomeViewController {
            if let appError = error as? AppError {
                switch appError {
                case .networkError, .serverError, .quotaExceeded:
                    homeVC.retryLastOperation()
                case .imageProcessingFailed, .characterNotFound:
                    homeVC.retryImageProcessing()
                default:
                    break
                }
            }
        }
    }
} 