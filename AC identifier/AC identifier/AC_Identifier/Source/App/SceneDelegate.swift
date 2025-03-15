import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("🟢 SceneDelegate: scene will connect")
        
        guard let windowScene = (scene as? UIWindowScene) else {
            print("❌ SceneDelegate: failed to cast scene to UIWindowScene")
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
        let contentView = ContentView()
        window.rootViewController = UIHostingController(rootView: contentView)
        self.window = window
        window.makeKeyAndVisible()
        
        print("✅ SceneDelegate: window setup complete")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("🟢 SceneDelegate: scene did disconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("🟢 SceneDelegate: scene did become active")
    }
}