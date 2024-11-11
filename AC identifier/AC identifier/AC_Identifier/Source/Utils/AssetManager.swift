import UIKit

enum AssetManager {
    static func setupAppIcon() {
        let fileManager = FileManager.default
        let appIconPath = Bundle.main.bundlePath + "/Assets.xcassets/AppIcon.appiconset"
        
        // 確保目錄存在
        if !fileManager.fileExists(atPath: appIconPath) {
            try? fileManager.createDirectory(atPath: appIconPath, withIntermediateDirectories: true)
        }
        
        // 檢查圖標文件
        let iconFiles = ["40.png", "60.png", "58.png", "87.png", "80.png", "120.png", "180.png", "1024.png"]
        for file in iconFiles {
            let filePath = (appIconPath as NSString).appendingPathComponent(file)
            if !fileManager.fileExists(atPath: filePath) {
                print("缺少圖標文件：\(file)")
            }
        }
    }
} 