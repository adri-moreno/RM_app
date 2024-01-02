
struct EpisodesResponse: Codable {
    var info: Info
    var results: [Episode]
}

struct Episode: Codable, Identifiable, Equatable {
    var id: Int
    var name: String
    var airDate: String
    var episode: String
    var characters: [String]
    var url: String
    var created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters, url, created
        case airDate = "air_date"
    }
    
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Episode: Searchable {
    func matches(query: String) -> Bool {
        return name.localizedCaseInsensitiveContains(query)
    }
}
