
import SwiftUI

struct CharacterRow: View {
    let character: Character
    
    var body: some View {
        HStack {
            CachedAsyncImage(urlString: character.image)
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .padding(.leading, 8)
            
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.headline)
                
                Text(character.status)
                    .font(.subheadline)
                
                Text(character.species)
                    .font(.subheadline)
            }
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    let character = Character(
        id: 1,
        name: "Rick Sanchez",
        status: "Alive",
        species: "Human",
        type: "",
        gender: "Male",
        origin: Origin(name: "Earth (C-137)",
                       url: "https://rickandmortyapi.com/api/location/1"),
        location: Origin(name: "Citadel of Ricks",
                         url: "https://rickandmortyapi.com/api/location/3"),
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episode: ["https://rickandmortyapi.com/api/episode/1"],
        url: "https://rickandmortyapi.com/api/character/1",
        created: "2017-11-04T18:48:46.250Z"
    )
    return CharacterRow(character: character)
}
