import Foundation

public enum AppError: LocalizedError {
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
    
    public var errorDescription: String? {
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
} 