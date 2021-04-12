import UIKit
import SwiftUI
import Foundation

class HostingController<Content> : UIHostingController<Content> where Content : View {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let content = ContentView()
            window.rootViewController = HostingController(rootView: content)
            self.window = window
            window.makeKeyAndVisible()
        }
    }    
}
