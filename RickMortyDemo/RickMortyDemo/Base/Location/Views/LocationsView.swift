
import SwiftUI

struct LocationsView: View {
    @ObservedObject var viewModel: RickMortyViewModel
    
    @Namespace private var topID
    @Namespace private var bottomID
    
    @State private var currentOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    if viewModel.filteredLocations.isEmpty {
                        Color.clear.frame(maxWidth: .infinity, maxHeight: .infinity)
                            .id(topID)
                    } else {
                        GoToButton(buttonText: "Go to Bottom ↓", proxy: proxy, id: bottomID)
                            .id(topID)
                    }
                    
                    ForEach(viewModel.filteredLocations) { location in
                        ExpandableView(
                            thumbnail: ThumbnailView(content: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(location.name)
                                            .font(.headline)
                                        
                                        Text("Type: \(location.type)")
                                            .font(.subheadline)
                                        
                                        Text("Dimension: \(location.dimension.replacingOccurrences(of: "Dimension", with: ""))")
                                            .font(.subheadline)
                                    }
                                    .padding()
                                    
                                    Spacer()
                                }
                            }),
                            expanded: ExpandedView(content: {
                                HStack {
                                    VStack {
                                        Text(location.name)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.title)
                                        
                                        ScrollView(.vertical) {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("Residents:")
                                                    .font(.title3)
                                                
                                                if !viewModel.characters(for: location).isEmpty {
                                                    LoopingScrollView(width: 150, spacing: 10, items: viewModel.characters(for: location)) { character in
                                                        CachedAsyncImage(urlString: character.image)
                                                            .cornerRadius(8)
                                                    }
                                                    .frame(height: 150)
                                                    .contentMargins(.horizontal, 16, for: .scrollContent)
                                                } else {
                                                    Text("No residents in this location.")
                                                        .frame(maxWidth: .infinity)
                                                        .frame(height: 50)
                                                }
                                            }
                                        }
                                        .scrollIndicators(.hidden)
                                    }
                                    .padding()
                                }
                            })
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    if !viewModel.filteredLocations.isEmpty {
                        GoToButton(buttonText: "Go to Top ↑", proxy: proxy, id: topID)
                            .id(bottomID)
                    }
                }
                .searchable(text: $viewModel.searchQuery, prompt: "Search locations...")
                .navigationTitle("Locations")
                .overlay {
                    if viewModel.filteredLocations.isEmpty && !viewModel.searchQuery.isEmpty {
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
    LocationsView(viewModel: RickMortyViewModel())
}
