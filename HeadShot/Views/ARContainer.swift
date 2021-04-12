import Foundation
import SwiftUI

struct ARContainer : UIViewControllerRepresentable {
    
    typealias UIViewControllerType = ARViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ARContainer>) -> ARViewController {
        return ARViewController()
    }
    
    func updateUIViewController(_ view: ARViewController, context: Context) {
        // noop
    }
}
