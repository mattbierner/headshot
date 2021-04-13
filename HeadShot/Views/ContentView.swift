import SwiftUI
import Combine

private struct Blur: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct ContentView: View {
    @State private var arController: ARViewController?
    
    var body: some View {        
        return ZStack(alignment: .bottom) {
            ARContainer(ref: { ref in
                DispatchQueue.main.async {
                    self.arController = ref
                }
            })
                .edgesIgnoringSafeArea(.top)
            
            HStack {
                Button("Export Texture Map", action: {
                    arController!.exportTextureMapToPhotos()
                })
                .padding(10)
                .background(Blur(style: .systemMaterial))
                .padding(.bottom, 10)
            }
        }
        .statusBar(hidden: true)
    }
}
