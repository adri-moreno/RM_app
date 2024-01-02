
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: RickMortyViewModel
    
    @State private var xAxis: CGFloat = .zero

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $viewModel.selectedTab) {
                CharactersView(viewModel: viewModel)
                    .tag(TabBar.characters)
                    .toolbar(.hidden, for: .tabBar)
                
                LocationsView(viewModel: viewModel)
                    .tag(TabBar.locations)
                    .toolbar(.hidden, for: .tabBar)
                
                EpisodesView(viewModel: viewModel)
                    .tag(TabBar.episodes)
                    .toolbar(.hidden, for: .tabBar)
            }
            if viewModel.isTabBarVisible {
                CustomTabBar(selectedTab: $viewModel.selectedTab, xAxis: $xAxis)
                    .transition(.move(edge: .bottom))
            }
        }
        .ignoresSafeArea()
        .errorView(viewModel.error, retryAction: viewModel.retryLoadingData)
    }
}

#Preview {
    HomeView(viewModel: RickMortyViewModel())
}
