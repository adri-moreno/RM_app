
import Foundation

protocol Searchable {
    var name: String { get }
}

struct APIResponse<T: Codable>: Codable {
    let info: Info
    let results: [T]
}

struct BaseAPI: Codable {
    let characters: String
    let locations: String
    let episodes: String
}

struct Info: Codable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
}

enum PermissionState {
    case idle, waiting
}

enum TabBar: CaseIterable {
    case characters, locations, episodes
        
    var title: String {
        switch self {
        case .characters:
            return "Characters"
        case .locations:
            return "Locations"
        case .episodes:
            return "Episodes"
        }
    }
    
    var image: String {
        switch self {
        case .characters:
            return "person.2.circle.fill"
        case .locations:
            return "map.circle.fill"
        case .episodes:
            return "tv.circle.fill"
        }
    }
}

enum DetailsPicker: String, CaseIterable {
    case locations = "Locations"
    case episodes = "Episodes"
}
