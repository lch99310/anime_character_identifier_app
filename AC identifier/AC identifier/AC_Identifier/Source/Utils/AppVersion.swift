import Foundation

enum AppVersion {
    static var current: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    static var build: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    static var fullVersion: String {
        return "\(current) (\(build))"
    }
    
    static func isFirstLaunch() -> Bool {
        let key = "HasLaunchedBefore"
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: key) {
            return false
        } else {
            defaults.set(true, forKey: key)
            return true
        }
    }
    
    static func isUpdateVersion() -> Bool {
        let key = "LastVersionInstalled"
        let defaults = UserDefaults.standard
        
        let lastVersion = defaults.string(forKey: key) ?? "0.0"
        let currentVersion = current
        
        if lastVersion != currentVersion {
            defaults.set(currentVersion, forKey: key)
            return true
        }
        
        return false
    }
} 