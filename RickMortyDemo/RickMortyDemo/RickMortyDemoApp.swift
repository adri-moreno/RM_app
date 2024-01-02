
import SwiftUI
import SwiftData

@main
struct RickMortyDemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(DataModelManager.shared.modelContainer)
    }
}
