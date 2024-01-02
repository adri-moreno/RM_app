
import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var viewModel = RickMortyViewModel()
    @StateObject private var launchManager = LaunchManager()
       
    var body: some View {
        ZStack {
            HomeView(viewModel: viewModel)
                .tint(.accent)
            
            if launchManager.state != .completed {
                LaunchView(launchManager: launchManager, 
                           viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
