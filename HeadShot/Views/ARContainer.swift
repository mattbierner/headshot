import Foundation
import SwiftUI

struct ARContainer : UIViewControllerRepresentable {
    
    typealias UIViewControllerType = ARViewController
    
    let ref: (ARViewController) -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<ARContainer>) -> ARViewController {
        let controller = ARViewController()
        ref(controller)
        return controller
    }
    
    func updateUIViewController(_ view: ARViewController, context: Context) {
        // noop
    }
}
