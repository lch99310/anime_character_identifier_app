import UIKit

enum ImageAssets {
    static func generateAppIcons(from originalImage: UIImage) {
        let sizes = [
            (40, "40.png"),
            (60, "60.png"),
            (58, "58.png"),
            (87, "87.png"),
            (80, "80.png"),
            (120, "120.png"),
            (180, "180.png"),
            (1024, "1024.png")
        ]
        
        let fileManager = FileManager.default
        let appIconPath = Bundle.main.bundlePath + "/Assets.xcassets/AppIcon.appiconset"
        
        // 創建目錄
        try? fileManager.createDirectory(atPath: appIconPath, withIntermediateDirectories: true)
        
        // 生成各種尺寸的圖標
        for (size, filename) in sizes {
            let iconSize = CGSize(width: size, height: size)
            UIGraphicsBeginImageContextWithOptions(iconSize, false, 1.0)
            originalImage.draw(in: CGRect(origin: .zero, size: iconSize))
            if let resizedImage = UIGraphicsGetImageFromCurrentImageContext(),
               let imageData = resizedImage.pngData() {
                let filePath = (appIconPath as NSString).appendingPathComponent(filename)
                try? imageData.write(to: URL(fileURLWithPath: filePath))
            }
            UIGraphicsEndImageContext()
        }
    }
} 