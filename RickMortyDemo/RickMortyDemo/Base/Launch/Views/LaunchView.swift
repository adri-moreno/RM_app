
import SwiftUI

struct LaunchView: View {
    @ObservedObject var launchManager: LaunchManager
    @ObservedObject var viewModel: RickMortyViewModel
    
    @State private var firstPhaseAnimated: Bool = false
    @State private var secondPhaseAnimated: Bool = false
    
    private let timer = Timer.publish(every: 0.75,
                                      on: .main,
                                      in: .common).autoconnect()
    
    private var background: some View {
        Color(.white)
            .ignoresSafeArea(edges: .all)
    }
    
    private var logo: some View {
        Image("portal")
            .scaleEffect(firstPhaseAnimated ? 0.35 : 0.75)
            .scaleEffect(secondPhaseAnimated ? UIScreen.main.bounds.height / 4 : 1)
    }
    
    var body: some View {
        ZStack {
            background
            logo
        }
        .onReceive(timer) { input in
            switch launchManager.state {
                case .first:
                    withAnimation(.spring) {
                        firstPhaseAnimated.toggle()
                    }
                    
                    if viewModel.permissionState == .idle {
                        launchManager.dismiss()
                    } else {}
                    
                case .second:
                    withAnimation(.easeInOut) {
                        secondPhaseAnimated.toggle()
                    }
                    
                default: break
            }
        }
        .opacity(secondPhaseAnimated ? 0 : 1)
    }
}

#Preview {
    LaunchView(launchManager: LaunchManager(), viewModel: RickMortyViewModel())
}
