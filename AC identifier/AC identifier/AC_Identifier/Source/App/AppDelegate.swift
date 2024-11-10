import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("🟢 AppDelegate: application did launch")
        
        AssetManager.setupAssets()
        
        if #available(iOS 13.0, *) {
            print("🟢 AppDelegate: using scene-based lifecycle")
        } else {
            print("🟢 AppDelegate: using legacy lifecycle")
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.backgroundColor = .white
            window?.rootViewController = SimpleWelcomeViewController()
            window?.makeKeyAndVisible()
            print("🟢 AppDelegate: window setup complete for legacy lifecycle")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        print("🟢 AppDelegate: creating scene configuration")
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        print("🟢 AppDelegate: scene configuration created")
        return sceneConfig
    }
} 