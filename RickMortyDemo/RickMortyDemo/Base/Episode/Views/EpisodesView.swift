
import SwiftUI

struct EpisodesView: View {
    @ObservedObject var viewModel: RickMortyViewModel
    
    @Namespace private var topID
    @Namespace private var bottomID
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    if viewModel.filteredEpisodes.isEmpty {
                        Color.clear.frame(maxWidth: .infinity, maxHeight: .infinity)
                            .id(topID)
                    } else {
                        GoToButton(buttonText: "Go to Bottom ↓", proxy: proxy, id: bottomID)
                            .id(topID)
                    }
                    
                    ForEach(viewModel.filteredEpisodes) { episode in
                        ExpandableView(thumbnail:
                                        ThumbnailView(content: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(episode.name)
                                        .font(.headline)
                                    
                                    Text(String.formatEpisodeCode(episode.episode))
                                        .font(.subheadline)
                                    
                                    Text(episode.airDate)
                                        .font(.subheadline)
                                }
                                .padding()
                                
                                Spacer()
                            }
                        }), expanded: ExpandedView(content: {
                            VStack {
                                Text(episode.name)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title)
                                
                                ScrollView(.vertical) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Characters:")
                                            .font(.title3)
                                        
                                        LoopingScrollView(width: 150, spacing: 10, items: viewModel.characters(for: episode)) { character in
                                            CachedAsyncImage(urlString: character.image)
                                                .cornerRadius(8)
                                        }
                                        .frame(height: 150)
                                        .contentMargins(.horizontal, 15, for: .scrollContent)
                                    }
                                }
                                .scrollIndicators(.hidden)
                            }
                            .padding()
                        }))
                        .onAppear {
                            if episode == viewModel.filteredEpisodes.last {
                                viewModel.isLastElementVisible = true
                            } else {
                                viewModel.isLastElementVisible = false
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    if !viewModel.filteredEpisodes.isEmpty {
                        GoToButton(buttonText: "Go to Top ↑", proxy: proxy, id: topID)
                            .id(bottomID)
                    }
                }
                .searchable(text: $viewModel.searchQuery, prompt: "Search episodes...")
                .navigationTitle("Episodes")
                .overlay {
                    if viewModel.filteredEpisodes.isEmpty && !viewModel.searchQuery.isEmpty {
                        ContentUnavailableView.search(text: viewModel.searchQuery)
                    }
                }
            }
            .onPreferenceChange(ViewOffsetKey.self) { value in
                let screenHeight = UIScreen.main.bounds.height + 10
                if value.max() ?? 0 <= screenHeight {
                    viewModel.isLastElementVisible = true
                } else {
                    viewModel.isLastElementVisible = false
                }
                viewModel.handleScrollChange()
            }
        }
    }
}

#Preview {
    EpisodesView(viewModel: RickMortyViewModel())
}
