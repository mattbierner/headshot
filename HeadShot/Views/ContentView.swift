import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {        
        return ZStack(alignment: .bottom) {
            ARContainer()
                .edgesIgnoringSafeArea(.top)
        }
        .statusBar(hidden: true)
    }
}
