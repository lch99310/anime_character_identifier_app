import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("🟢 SceneDelegate: scene will connect")
        
        guard let windowScene = (scene as? UIWindowScene) else {
            print("❌ SceneDelegate: failed to cast scene to UIWindowScene")
            return
        }
        
        do {
            try setupWindow(with: windowScene)
        } catch {
            print("❌ SceneDelegate: failed to setup window: \(error)")
        }
    }
    
    private func setupWindow(with windowScene: UIWindowScene) throws {
        print("🟢 SceneDelegate: setting up window")
        
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .white
        print("🟢 SceneDelegate: window created")
        
        let viewController = SimpleWelcomeViewController()
        window.rootViewController = viewController
        print("🟢 SceneDelegate: root view controller set")
        
        window.makeKeyAndVisible()
        self.window = window
        print("✅ SceneDelegate: window setup complete")
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        print("🟢 SceneDelegate: scene did disconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("🟢 SceneDelegate: scene did become active")
    }
} 