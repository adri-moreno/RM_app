
import Foundation

enum LaunchPhase {
    case first
    case second
    case completed
}

final class LaunchManager: ObservableObject {
    @Published private(set) var state: LaunchPhase = .first
    
    func dismiss() {
        self.state = .second
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.state = .completed
        }
    }
}
