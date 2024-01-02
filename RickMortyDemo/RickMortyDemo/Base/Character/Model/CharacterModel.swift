
struct CharacterResponse: Codable {
    var info: Info
    var results: [Character]
}

struct Character: Codable, Identifiable, Equatable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var origin: Origin
    var location: Origin
    var image: String
    var episode: [String]
    var url: String
    var created: String
    
    init(id: Int, name: String, status: String, species: String, type: String, gender: String,
         origin: Origin, location: Origin, image: String, episode: [String], url: String, created: String) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.origin = origin
        self.location = location
        self.image = image
        self.episode = episode
        self.url = url
        self.created = created
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, status, species, type, gender, origin, location, image, episode, url, created
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Origin: Codable {
    let name: String
    let url: String
}

extension Character: Searchable {
    func matches(query: String) -> Bool {
        return name.localizedCaseInsensitiveContains(query)
    }
}
