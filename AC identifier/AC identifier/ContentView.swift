import SwiftUI
import UIKit

struct ContentView: View {
    var body: some View {
        WelcomeView()
            .ignoresSafeArea()
    }
}

struct WelcomeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let welcomeVC = SimpleWelcomeViewController()
        let navigationController = UINavigationController(rootViewController: welcomeVC)
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Updates handled by the view controller
    }
}

#Preview {
    ContentView()
}