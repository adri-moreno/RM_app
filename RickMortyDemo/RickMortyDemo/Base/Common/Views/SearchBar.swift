
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onEditingChanged: (Bool) -> Void = { _ in }
    
    var body: some View {
        TextField("Search by...", text: $text, onEditingChanged: onEditingChanged)
            .padding(16)
            .background(Color(.accent))
            .cornerRadius(32)
            .padding(.horizontal)
    }
}

#Preview {
    Group {
        SearchBar(text: .constant(""))
            .previewLayout(.sizeThatFits)
    }
}
