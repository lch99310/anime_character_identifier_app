import UIKit

class ImageProcessor {
    func processImage(_ image: UIImage) -> UIImage? {
        let maxDimension = AppConfig.maxImageDimension
        let size = image.size
        
        // 計算新尺寸
        var newSize: CGSize
        if size.width > size.height {
            let ratio = maxDimension / size.width
            newSize = CGSize(width: maxDimension, height: size.height * ratio)
        } else {
            let ratio = maxDimension / size.height
            newSize = CGSize(width: size.width * ratio, height: maxDimension)
        }
        
        // 創建新的圖片
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        defer { UIGraphicsEndImageContext() }
        
        // 繪製圖片
        image.draw(in: CGRect(origin: .zero, size: newSize))
        guard let processedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        return processedImage
    }
    
    func compressImage(_ image: UIImage, maxSizeKB: Int = 1024) -> Data? {
        var compression: CGFloat = 1.0
        let maxBytes = maxSizeKB * 1024
        
        guard var imageData = image.jpegData(compressionQuality: compression) else {
            return nil
        }
        
        // 逐步降低質量直到達到目標大小
        while imageData.count > maxBytes && compression > 0.1 {
            compression -= 0.1
            if let newData = image.jpegData(compressionQuality: compression) {
                imageData = newData
            }
        }
        
        return imageData
    }
} 