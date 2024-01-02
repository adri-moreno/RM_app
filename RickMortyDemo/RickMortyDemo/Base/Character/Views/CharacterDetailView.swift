
import SwiftUI

struct CharacterDetailView: View {
    var character: Character
    var locations: [Location]
    var episodes: [Episode]
    
    @Binding var isTabBarVisible: Bool
    @State private var isExpanded = false
    @State private var selectedPicker: DetailsPicker = .locations
    @Namespace private var animation

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    CachedAsyncImage(urlString: character.image)
                        .frame(width: geometry.size.width * 0.4,
                               height: geometry.size.width * 0.4)
                        .cornerRadius(8)
                        .shadow(radius: 5)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(character.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Status: \(character.status)")
                            .font(.title3)
                        
                        Text("Species: \(character.species)")
                            .font(.title3)

                        if !character.type.isEmpty {
                            Text("Type: \(character.type)")
                        }
                        
                        Text("Gender: \(character.gender)")
                            .font(.title3)
                    }
                    .padding(.trailing, 8)
                }
                .background(Color(.background))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                DisclosureGroup(
                    content: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Origin: \(character.origin.name)")
                                .font(.body)
                                .padding(.bottom, 2)
                            
                            Text("Location: \(character.location.name)")
                                .font(.body)
                                .padding(.bottom, 2)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.background))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    },
                    label: {
                        Text("More Details")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                )
                .tint(Color(.accent))
                .padding(.vertical, 8)
                       
                CustomSegmentedPicker()
                    .padding(.vertical)
                
                List {
                    switch selectedPicker {
                        case .locations:
                            if locations.isEmpty {
                                Text("No results found")
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                ForEach(locations, id: \.id) { location in
                                    Text(location.name)
                                        .font(.headline)
                                        .listRowBackground(Color(.background))
                                }
                            }
                        case .episodes:
                            if episodes.isEmpty {
                                Text("No results found")
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                ForEach(episodes, id: \.id) { episode in
                                    Text(episode.name)
                                        .font(.headline)
                                        .listRowBackground(Color(.background))
                                }
                            }
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color(.background))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 32)
        }
        .onAppear {
            isTabBarVisible = false
        }
        .onDisappear {
            isTabBarVisible = true
        }
    }
    
    
    @ViewBuilder
    func CustomSegmentedPicker() -> some View {
        HStack(spacing: 0) {
            ForEach(DetailsPicker.allCases, id: \.rawValue) { picker in
                Text(picker.rawValue)
                    .fontWeight(.bold)
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background {
                        if picker == selectedPicker {
                            Capsule()
                                .fill(Color(.accent))
                                .matchedGeometryEffect(id: "ACTIVETAB",
                                                       in: animation)
                        }
                    }
                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedPicker = picker
                        }
                    }
            }
        }
        .background(.gray.opacity(0.15), in: .capsule)
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
    
    let locations = [
        Location(id: 1,
                 name: "Earth (C-137)",
                 type: "Planet",
                 dimension: "Dimension C-137",
                 residents: [
                    "https://rickandmortyapi.com/api/character/38",
                    "https://rickandmortyapi.com/api/character/45",
                    "https://rickandmortyapi.com/api/character/71"
                 ],
                 url: "https://rickandmortyapi.com/api/location/1",
                 created: "2017-11-10T12:42:04.162Z"),
        Location(id: 2,
                 name: "Abadango",
                 type: "Cluster",
                 dimension: "unknown",
                 residents: ["https://rickandmortyapi.com/api/character/6"],
                 url: "https://rickandmortyapi.com/api/location/2",
                 created: "2017-11-10T13:06:38.182Z")
    ]
    
    let episodes = [
        Episode(id: 1,
                name: "Pilot",
                airDate: "December 2, 2013",
                episode: "S01E01",
                characters: [
                    "https://rickandmortyapi.com/api/character/1",
                    "https://rickandmortyapi.com/api/character/2"
                  ],
                url: "https://rickandmortyapi.com/api/episode/1",
                created: "2017-11-10T12:56:33.798Z"),
        Episode(id: 2,
                name: "Lawnmower Dog",
                airDate: "December 9, 2013",
                episode: "S01E02",
                characters: [
                    "https://rickandmortyapi.com/api/character/1",
                    "https://rickandmortyapi.com/api/character/2"
                  ],
                url: "https://rickandmortyapi.com/api/episode/2",
                created: "2017-11-10T12:56:33.798Z"),
        Episode(id: 3,
                name: "Anatomy Park",
                airDate: "December 16, 2013",
                episode: "S01E03",
                characters: [
                    "https://rickandmortyapi.com/api/character/1",
                    "https://rickandmortyapi.com/api/character/2"
                  ],
                url: "https://rickandmortyapi.com/api/episode/1",
                created: "2017-11-10T12:56:33.798Z")
    ]
    
    return CharacterDetailView(character: character, 
                               locations: locations,
                               episodes: episodes,
                               isTabBarVisible: .constant(false))
}
