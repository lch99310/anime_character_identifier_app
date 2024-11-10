import UIKit

enum AssetManager {
    static func setupAssets() {
        // 確保Assets.xcassets目錄存在
        let fileManager = FileManager.default
        let assetsPath = Bundle.main.bundlePath + "/Assets.xcassets"
        if !fileManager.fileExists(atPath: assetsPath) {
            do {
                try fileManager.createDirectory(atPath: assetsPath, withIntermediateDirectories: true)
            } catch {
                print("Error creating assets directory: \(error)")
            }
        }
    }
} 