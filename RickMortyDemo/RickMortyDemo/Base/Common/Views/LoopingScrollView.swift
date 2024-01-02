
import SwiftUI

struct LoopingScrollView<Content: View, Character: RandomAccessCollection>: View where Character.Element: Identifiable {
    var width: CGFloat
    var spacing: CGFloat = 0
    var items: Character
    
    @ViewBuilder var content: (Character.Element) -> Content
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: spacing) {
                ForEach(items) { item in
                    content(item)
                        .frame(width: width)
                }
            }
        }
    }
}
