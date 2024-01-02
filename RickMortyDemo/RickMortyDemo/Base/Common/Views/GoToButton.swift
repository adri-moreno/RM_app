
import SwiftUI

struct GoToButton: View {
    @State var buttonText: String
    @State var proxy: ScrollViewProxy
    @State var id: Namespace.ID
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: ViewOffsetKey.self,
                                   value: [geometry.frame(in: .named("list")).minY])
            HStack {
                Spacer()
                
                Button(buttonText) {
                    withAnimation {
                        proxy.scrollTo(id)
                    }
                }
                .foregroundColor(.accent)
                
                Spacer()
            }
        }
    }
}
