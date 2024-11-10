import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        
        // 設置緩存限制
        cache.countLimit = 100 // 最多緩存100張圖片
        cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB
    }
    
    func store(_ image: UIImage, forKey key: String) {
        let cacheKey = NSString(string: key)
        cache.setObject(image, forKey: cacheKey)
        
        // 同時保存到磁盤
        if let data = image.jpegData(compressionQuality: 0.8) {
            let fileURL = cacheDirectory.appendingPathComponent(key)
            try? data.write(to: fileURL)
        }
    }
    
    func retrieve(forKey key: String) -> UIImage? {
        let cacheKey = NSString(string: key)
        
        // 先從內存緩存中查找
        if let cachedImage = cache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        // 如果內存中沒有，從磁盤加載
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            // 加載後放入內存緩存
            cache.setObject(image, forKey: cacheKey)
            return image
        }
        
        return nil
    }
    
    func removeImage(forKey key: String) {
        let cacheKey = NSString(string: key)
        cache.removeObject(forKey: cacheKey)
        
        let fileURL = cacheDirectory.appendingPathComponent(key)
        try? fileManager.removeItem(at: fileURL)
    }
    
    func clearCache() {
        cache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
} 