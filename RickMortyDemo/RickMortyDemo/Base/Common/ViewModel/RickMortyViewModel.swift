
import Combine
import SwiftUI

class RickMortyViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var locations: [Location] = []
    @Published var episodes: [Episode] = []
    @Published var error: Error?
    @Published var searchQuery = ""

    @Published var selectedTab: TabBar = .characters
    @Published var isLastElementVisible: Bool = false
    @Published var isTabBarVisible: Bool = true
    private var scrollTimer: Timer?
    private var lastScrollUpdateTime = Date()
    
    private var charactersForLocationCache: [Int: [Character]] = [:]
    private var charactersForEpisodeCache: [Int: [Character]] = [:]
    private var episodesCache: [Int: [Episode]] = [:]
    private var locationsCache: [Int: [Location]] = [:]

    private var cancellables = Set<AnyCancellable>()
    private let baseAPIURL = "https://rickandmortyapi.com/api/"
    
    var permissionState: PermissionState?

    init() {
        fetchBaseAPI()
    }
    
    func retryLoadingData() {
        self.error = nil
        fetchBaseAPI()
    }

    private func fetchBaseAPI() {
        guard let url = URL(string: baseAPIURL) else {
            self.error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: BaseAPI.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error
                }
            }, receiveValue: { [weak self] baseAPI in
                self?.fetchData(urlString: baseAPI.characters, for: \.characters)
                self?.fetchData(urlString: baseAPI.locations, for: \.locations)
                self?.fetchData(urlString: baseAPI.episodes, for: \.episodes)
            })
            .store(in: &cancellables)
    }

    private func fetchData<T: Codable>(urlString: String, for keyPath: ReferenceWritableKeyPath<RickMortyViewModel, [T]>) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: APIResponse<T>.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.permissionState = .idle
                case .failure(let error):
                    self.error = error
                    self.permissionState = .idle
                }
            }, receiveValue: { [weak self] response in
                let newResults = (self?[keyPath: keyPath] ?? []) + response.results
                self?[keyPath: keyPath] = newResults

                if let nextURL = response.info.next {
                    self?.fetchData(urlString: nextURL, for: keyPath)
                }
            })
            .store(in: &cancellables)
    }

    var filteredCharacters: [Character] {
        filter(searchQuery, in: characters)
    }
    
    var filteredLocations: [Location] {
        filter(searchQuery, in: locations)
    }

    var filteredEpisodes: [Episode] {
        filter(searchQuery, in: episodes)
    }
    
    private func filter<T: Searchable>(_ query: String, in items: [T]) -> [T] {
        if query.isEmpty {
            return items
        } else {
            return items.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
    }

    func characters(for location: Location) -> [Character] {
        if let cached = charactersForLocationCache[location.id] {
            return cached
        }
        let filtered = characters.filter { $0.location.url == location.url }
        charactersForLocationCache[location.id] = filtered
        return filtered
    }

    func characters(for episode: Episode) -> [Character] {
        if let cached = charactersForEpisodeCache[episode.id] {
            return cached
        }
        let filtered = characters.filter { $0.episode.contains(episode.url) }
        charactersForEpisodeCache[episode.id] = filtered
        return filtered
    }

    func locations(for character: Character) -> [Location] {
        if let cached = locationsCache[character.id] {
            return cached
        }
        let filtered = locations.filter { $0.residents.contains(character.url) }
        locationsCache[character.id] = filtered
        return filtered
    }
    
    func episodes(for character: Character) -> [Episode] {
        if let cached = episodesCache[character.id] {
            return cached
        }
        let filtered = episodes.filter { $0.characters.contains(character.url) }
        episodesCache[character.id] = filtered
        return filtered
    }
    
    func handleScrollChange() {
        let now = Date()
        let updateInterval = 1.0
        
        if now.timeIntervalSince(lastScrollUpdateTime) > updateInterval {
            lastScrollUpdateTime = now
            restartScrollTimer()
        }
    }
    
    private func restartScrollTimer() {
        scrollTimer?.invalidate()
        isTabBarVisible = false
        
        scrollTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.isTabBarVisible = self?.isLastElementVisible == true ? false : true
        }
    }
}
