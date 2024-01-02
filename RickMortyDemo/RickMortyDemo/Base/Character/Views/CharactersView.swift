
import SwiftUI

struct CharactersView: View {
    @ObservedObject var viewModel: RickMortyViewModel
    
    @Namespace private var topID
    @Namespace private var bottomID
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                CharacterListView(viewModel: viewModel, proxy: proxy)
            }
            .onPreferenceChange(ViewOffsetKey.self) { value in
                viewModel.handleScrollChange()
            }
        }
    }
}

struct CharacterListView: View {
    @ObservedObject var viewModel: RickMortyViewModel
    let proxy: ScrollViewProxy
    
    @Namespace private var topID
    @Namespace private var bottomID
    
    var body: some View {
        List {
            if !viewModel.filteredEpisodes.isEmpty {
                GoToButton(buttonText: "Go to Bottom ↓", proxy: proxy, id: bottomID)
                    .frame(height: 0)
                    .id(topID)
            }
            
            ForEach(viewModel.filteredCharacters) { character in
                CharacterRowWithNavigation(viewModel: viewModel, character: character)
            }
            
            if !viewModel.filteredEpisodes.isEmpty {
                GoToButton(buttonText: "Go to Top ↑", proxy: proxy, id: topID)
                    .id(bottomID)
            }
            
        }
        .listStyle(PlainListStyle())
        .background(Color(.background))
        .searchable(text: $viewModel.searchQuery, prompt: "Search characters by name...")
        .navigationTitle("Characters")
        .overlay {
            if viewModel.filteredCharacters.isEmpty && !viewModel.searchQuery.isEmpty {
                ContentUnavailableView.search(text: viewModel.searchQuery)
            }
        }
    }
}

struct CharacterRowWithNavigation: View {
    @ObservedObject var viewModel: RickMortyViewModel
    let character: Character
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.background))
            
            NavigationLink(
                destination: CharacterDetailView(character: character,
                                                 locations: viewModel.locations(for: character),
                                                 episodes: viewModel.episodes(for: character),
                                                 isTabBarVisible: $viewModel.isTabBarVisible)
            ) {
                CharacterRow(character: character)
                    .onAppear {
                        if character == viewModel.filteredCharacters.last {
                            viewModel.isLastElementVisible = true
                        } else {
                            viewModel.isLastElementVisible = false
                        }
                    }
            }
            .padding(.trailing, 8)
        }
        .padding(.top, 8)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    CharactersView(viewModel: RickMortyViewModel())
}
