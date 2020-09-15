import Foundation
import Model
import SwiftUI
import SwiftRedux
import UIComponents

public struct CharacterListState: Equatable {
    public var searchText: String
    public var seasonAppeanceSelected: Int = 0
    public var loadedCharacters: [Character]
    public var filteredCharacters: [Character]

    public init(
        searchText: String,
        loadedCharacters: [Character],
        filteredCharacters: [Character],
        seasonAppearanceSelected: Int = 0
    ) {
        self.searchText = searchText
        self.loadedCharacters = loadedCharacters
        self.filteredCharacters = filteredCharacters
        self.seasonAppeanceSelected = seasonAppearanceSelected
    }
}

public enum CharacterListAction: Equatable {
    case searchText(String)
    case seasonAppearance(Int)
}

public func characterListReducer(
    state: inout CharacterListState,
    action: CharacterListAction
) -> [Effect<CharacterListAction>] {

    switch action {
    case let .searchText(text):
        state.searchText = text
        state.filteredCharacters = state.loadedCharacters.filter {
            match(name: $0.name, searchText: state.searchText) && match(appearance: $0.appearance, season: state.seasonAppeanceSelected)
        }
        return []
    case let .seasonAppearance(season):
        state.seasonAppeanceSelected = season
        state.filteredCharacters = state.loadedCharacters.filter {
            match(name: $0.name, searchText: state.searchText) && match(appearance: $0.appearance, season: state.seasonAppeanceSelected)
        }
        return []
    }
}

private func match(name: String, searchText: String) -> Bool {
    guard !searchText.isEmpty else { return true }
    return name.contains(searchText)
}

private func match(appearance: [Int], season: Int) -> Bool {
    if season == 0 { return true } 
    return appearance.contains(season)
}

public struct CharacterListView: View {

    @ObservedObject var store: Store<CharacterListState, CharacterListAction>
    @State private var showingSheet = false

    public init(store: Store<CharacterListState, CharacterListAction>) {
        self.store = store
    }

    let seasonsTexts = [
        0: "All seasons",
        1: "Season 1",
        2: "Season 2",
        3: "Season 3",
        4: "Season 4",
        5: "Season 5"
    ]

    public var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: Binding(get: {
                    self.store.value.searchText
                }, set: { newValue in
                    self.store.send(.searchText(newValue))
                }))

                Section(header: Text(seasonsTexts[self.store.value.seasonAppeanceSelected] ?? "All seasons")) {
                    List(self.store.value.filteredCharacters, id: \.id) { char in
                        NavigationLink.init(destination: CharacterDetailView(character: char)) {
                            CharacterRow(name: char.name, image: char.image)
                        }
                    }
                }

            }
            .navigationBarItems(trailing: Button(
                action: { self.showingSheet = true },
                label: { Text("Filter") }
            )
                .actionSheet(isPresented: self.$showingSheet) {
                    ActionSheet(
                            title: Text("Seasons"),
                            message: Text("Filter by season appearance"),
                            buttons: [
                                .default(Text("Season 1"), action: { self.store.send(.seasonAppearance(1))} ),
                                .default(Text("Season 2"), action: { self.store.send(.seasonAppearance(2))} ),
                                .default(Text("Season 3"), action: { self.store.send(.seasonAppearance(3))} ),
                                .default(Text("Season 4"), action: { self.store.send(.seasonAppearance(4))} ),
                                .default(Text("Season 5"), action: { self.store.send(.seasonAppearance(5))} ),
                                .cancel(Text("Reset filter"), action: { self.store.send(.seasonAppearance(0)) })
                            ]
                        )
                    }
            )
            .navigationBarTitle("Breaking bad")
        }

    }
}

struct CharacterListView_Previews: PreviewProvider {

    static let characters = [
        Character(
            id: 1,
            name: "Walter White",
            image: URL(string: "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg")!,
            appearance: [1,2,3,4,5],
            status: "Deceased",
            nickname: "Heisenberg",
            occupation: [
                "High School Chemistry Teacher",
                "Meth King Pin"
        ]),
        Character(
               id: 2,
               name: "Skyler White",
               image: URL(string: "https://s-i.huffpost.com/gen/1317262/images/o-ANNA-GUNN-facebook.jpg")!,
               appearance: [2,3,4,5],
               status: "Alive",
               nickname: "Sky",
               occupation: [

           ])
    ]

    static var previews: some View {
        CharacterListView(store: Store<CharacterListState, CharacterListAction>(
            initialValue: CharacterListState(
                searchText: "",
                loadedCharacters: characters,
                filteredCharacters: characters
            ),
            reducer: characterListReducer
            )
        )
    }
}


public struct CharacterDetailView: View {
    let character: Character

    public var body: some View {

        ZStack() {

            AsyncImage(url: character.image, placeholder: ActivityIndicator.init(isAnimating: .constant(true), style: .large)) { $0.resizable() }
                .scaledToFill()

            VStack(spacing: 50) {
                VStack() {
                    Text("Nickname:").fontWeight(.bold)
                    Text(character.nickname)
                }

                VStack {
                    Text("Occupation: ").fontWeight(.bold)
                    Text(character.occupation.joined(separator: ", "))
                    }

                VStack {
                    Text("Status: ").fontWeight(.bold)
                    Text(character.status)
                }
                VStack {
                    Text("Appearance: ").fontWeight(.bold)
                    Text("Season \(character.appearance.map(String.init).joined(separator: ", "))")
                }

            }
            .foregroundColor(.white)
            .padding(36)

        }
        .navigationBarTitle(character.name)
    }
}

struct CharacterDetails_Previews: PreviewProvider {
    static var previews: some View {

        NavigationView {
            CharacterDetailView(
                character: Character(
                    id: 1,
                    name: "Walter White",
                    image: URL(string: "https://images.amcnetworks.com/amc.com/wp-content/uploads/2015/04/cast_bb_700x1000_walter-white-lg.jpg")!,
                    appearance: [1,2,3,4,5],
                    status: "Deceased",
                    nickname: "Heisenberg",
                    occupation: [
                        "High School Chemistry Teacher",
                        "Meth King Pin"
                ])
            )
        }
    }
}



struct CharacterRow: View {

    var name: String
    var image: URL
    var body: some View {
        HStack {
            AsyncImage(url: image,
                       placeholder: ActivityIndicator(isAnimating: .constant(true), style: .medium)) {
                $0.resizable()
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 50, height: 50)
            Text(name)
            Spacer()
        }
    }
}


struct ActivityIndicator: UIViewRepresentable {

    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

public struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    private let configuration: (Image) -> Image

    public init(url: URL, cache: ImageCache? = nil, placeholder: Placeholder? = nil, configuration: @escaping (Image) -> Image = { $0 }) {
        loader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
        self.configuration = configuration
    }

    public var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }

    public var image: some View {
        Group {
            if loader.image != nil {
                configuration(Image(uiImage: loader.image!))
            } else {
                placeholder
            }
        }
    }
}



