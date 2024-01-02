
import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabBar
    @Binding var xAxis: CGFloat
    
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                ForEach(TabBar.allCases, id: \.self) { tab in
                    GeometryReader { reader in
                        Button {
                            withAnimation(Animation.interactiveSpring(dampingFraction: 2)) {
                                selectedTab = tab
                                xAxis = reader.frame(in: .global).midX
                            }
                        } label: {
                            Image(systemName: tab.image)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(tab == selectedTab ? Color(.accent) : Color.gray)
                                .background(
                                    Color(.aspect)
                                        .opacity(selectedTab == tab ? 1 : 0)
                                        .clipShape(Circle())
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(.aspect, lineWidth: 4)
                                }
                                .matchedGeometryEffect(id: tab, in: animation)
                                .offset(x: 0, y: selectedTab == tab ? -40 : 0)
                        }
                        .onAppear {
                            if selectedTab == .characters {
                                xAxis = 80
                            }
                        }
                    }
                    .frame(width: 60, height: 60)
                    
                    if tab != TabBar.allCases.last {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, 50)
            .padding(.top, 10)
            .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity)
        .background(
            CustomTabBarShape(xAxis: xAxis)
                .fill(Color(.aspect))
                .ignoresSafeArea()
                .overlay(
                    CustomTabBarShape(xAxis: xAxis)
                        .stroke(.accent, lineWidth: 4)
                )
        )
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(TabBar.characters), xAxis: .constant(80))
}
