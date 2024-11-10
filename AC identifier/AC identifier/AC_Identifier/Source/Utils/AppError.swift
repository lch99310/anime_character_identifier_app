import Foundation

enum AppError: LocalizedError, Equatable {
    case configurationError
    case networkError
    case serverError(Int)
    case imageProcessingFailed
    case cameraAccessDenied
    case photoLibraryAccessDenied
    case apiError(String)
    case characterNotFound
    case userAgentRequired
    case invalidURL
    case unknownError
    case quotaExceeded
    case rateLimitExceeded
    case invalidResponse
    
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.configurationError, .configurationError),
             (.networkError, .networkError),
             (.imageProcessingFailed, .imageProcessingFailed),
             (.cameraAccessDenied, .cameraAccessDenied),
             (.photoLibraryAccessDenied, .photoLibraryAccessDenied),
             (.characterNotFound, .characterNotFound),
             (.userAgentRequired, .userAgentRequired),
             (.invalidURL, .invalidURL),
             (.unknownError, .unknownError),
             (.quotaExceeded, .quotaExceeded),
             (.rateLimitExceeded, .rateLimitExceeded),
             (.invalidResponse, .invalidResponse):
            return true
        case (.serverError(let a), .serverError(let b)):
            return a == b
        case (.apiError(let a), .apiError(let b)):
            return a == b
        default:
            return false
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .configurationError:
            return "API配置錯誤，請確保所有API密鑰都已正確設置"
        case .networkError:
            return "網絡連接失敗，請檢查網絡設置"
        case .serverError(let code):
            return "伺服器錯誤（狀態碼：\(code)）"
        case .imageProcessingFailed:
            return "圖片處理失敗，請重試"
        case .cameraAccessDenied:
            return "無法訪問相機，請在設置中允許訪問相機權限"
        case .photoLibraryAccessDenied:
            return "無法訪問相冊，請在設置中允許訪問相冊權限"
        case .apiError(let message):
            return "API錯誤：\(message)"
        case .characterNotFound:
            return "無法找到該角色的信息，請嘗試其他圖片"
        case .userAgentRequired:
            return "API訪問被拒絕，請確保設置了正確的User-Agent"
        case .invalidURL:
            return "無效的URL請求"
        case .quotaExceeded:
            return "API使用配額已達上限，請稍後重試"
        case .rateLimitExceeded:
            return "請求頻率過高，請稍後重試"
        case .invalidResponse:
            return "無效的API響應"
        case .unknownError:
            return "發生未知錯誤，請重試"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .configurationError:
            return "請聯繫開發者處理API配置問題"
        case .networkError:
            return "請確保設備已連接到網絡"
        case .serverError:
            return "請稍後重試，如果問題持續存在請聯繫開發者"
        case .imageProcessingFailed:
            return "請嘗試使用其他圖片或降低圖片大小"
        case .cameraAccessDenied, .photoLibraryAccessDenied:
            return "請前往設置開啟相關權限"
        case .characterNotFound:
            return "請確保圖片中包含清晰的動漫角色"
        case .userAgentRequired:
            return "請聯繫開發者處理API訪問問題"
        case .quotaExceeded, .rateLimitExceeded:
            return "請等待一段時間後再試"
        case .invalidURL:
            return "請確保輸入的URL正確"
        case .invalidResponse:
            return "請重試，如果問題持續存在請聯繫開發者"
        default:
            return "如果問題持續存在請重啟應用"
        }
    }
} 