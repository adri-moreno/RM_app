
struct LocationResponse: Codable {
    var info: Info
    var results: [Location]
}

struct Location: Codable, Identifiable, Equatable {
    var id: Int
    var name: String
    var type: String
    var dimension: String
    var residents: [String]
    var url: String
    var created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, dimension, residents, url, created
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Location: Searchable {
    func matches(query: String) -> Bool {
        return name.localizedCaseInsensitiveContains(query)
    }
}
