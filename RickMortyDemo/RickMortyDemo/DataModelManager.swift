
import SwiftData

class DataModelManager {
    static let shared = DataModelManager()
    
    var modelContainer: ModelContainer
    
    init() {
        let schema = Schema([
            Item.self,
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema,
                                                    isStoredInMemoryOnly: false)
        
        do {
            modelContainer = try ModelContainer(for: schema,
                                                configurations: modelConfiguration)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
