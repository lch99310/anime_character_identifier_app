import Foundation

enum LogLevel: String {
    case debug = "📝"
    case info = "ℹ️"
    case warning = "⚠️"
    case error = "❌"
}

class Logger {
    static let shared = Logger()
    private let isDebug: Bool
    
    private init() {
        #if DEBUG
        isDebug = true
        #else
        isDebug = false
        #endif
    }
    
    func log(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        guard isDebug else { return }
        
        let fileName = (file as NSString).lastPathComponent
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let timestamp = dateFormatter.string(from: Date())
        
        let logMessage = "\(timestamp) \(level.rawValue) [\(fileName):\(line)] \(function): \(message)"
        print(logMessage)
        
        // TODO: 可以添加寫入文件或發送到遠程日誌服務的功能
    }
    
    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }
    
    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }
    
    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }
    
    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
} 