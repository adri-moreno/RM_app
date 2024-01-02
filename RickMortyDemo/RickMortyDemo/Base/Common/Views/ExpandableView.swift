
import SwiftUI

struct ExpandableView: View {
    @Namespace private var namespace
    @State private var expand = false
    
    var thumbnail: ThumbnailView
    var expanded: ExpandedView
    
    var body: some View {
        ZStack {
            if !expand {
                thumbnailView()
            } else {
                expandedView()
            }
        }
        .onTapGesture {
            if !expand {
                withAnimation(.spring(response: 0.6,
                                      dampingFraction: 0.8)) {
                    expand.toggle()
                }
            }
        }
    }
    
    @ViewBuilder
    private func thumbnailView() -> some View {
        ZStack {
            thumbnail
                .matchedGeometryEffect(id: "view", in: namespace)
        }
        .background(
            Color(.background)
                .matchedGeometryEffect(id: "background", in: namespace)
        )
        .mask(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .matchedGeometryEffect(id: "mask", in: namespace)
        )
    }
    
    @ViewBuilder
    private func expandedView() -> some View {
        ZStack {
            expanded
                .matchedGeometryEffect(id: "view", in: namespace)
                .background(
                    Color(.background)
                        .matchedGeometryEffect(id: "background", in: namespace)
                )
                .mask(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .matchedGeometryEffect(id: "mask", in: namespace)
                )
            
            Button(action: {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    expand.toggle()
                }
            }, label: {
                Image(systemName: "xmark")
                    .foregroundStyle(.accent)
            })
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .matchedGeometryEffect(id: "mask", in: namespace)
        }
    }
}

struct ThumbnailView: View, Identifiable {
    var id = UUID()
    @ViewBuilder var content: any View
    
    var body: some View {
        ZStack {
            AnyView(content)
        }
    }
}

struct ExpandedView: View, Identifiable {
    var id = UUID()
    @ViewBuilder var content: any View
    
    var body: some View {
        ZStack {
            AnyView(content)
        }
    }
}
