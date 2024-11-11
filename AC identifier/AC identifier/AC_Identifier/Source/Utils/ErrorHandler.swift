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
            
            alert.addAction(UIAlertAction(title: "確定", style: .cancel))
            
            viewController.present(alert, animated: true)
        }
    }
    
    private static func getErrorMessage(from error: Error) -> String {
        if let appError = error as? AppError {
            return appError.errorDescription ?? "未知錯誤"
        }
        return error.localizedDescription
    }
} 