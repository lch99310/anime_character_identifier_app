import SwiftUI
import UIKit

@main
struct AC_identifierApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Configure appearance
                    if #available(iOS 13.0, *) {
                        UINavigationBar.appearance().tintColor = .systemBlue
                        UINavigationBar.appearance().prefersLargeTitles = true
                    }
                }
        }
    }
}