import SwiftReduxTestSupport
import XCTest
@testable import Model
@testable import CharacterList

class CharacterListTests: XCTestCase {

    func testFilterCharactersByText() {

        let characters: [Actor] = [
            Actor(name: "Walter White"),
            Actor(name: "Skyler White"),
            Actor(name: "Mike Ehrmantraut")
        ]

        let state = CharacterListState(
            searchText: "",
            loadedCharacters: characters,
            filteredCharacters: characters,
            seasonAppearanceSelected: 0
        )

        assert(initialValue: state,
               reducer: characterListReducer,
               steps:
            Step(.send, .searchText("Wh"), {
                $0.searchText = "Wh"
                $0.filteredCharacters = [
                    Actor(name: "Walter White"),
                    Actor(name: "Skyler White"),
                ]
            }),
               Step(.send, .searchText(""), {
                $0.searchText = ""
                $0.filteredCharacters = [
                    Actor(name: "Walter White"),
                    Actor(name: "Skyler White"),
                    Actor(name: "Mike Ehrmantraut")
                ]
               })
        )
    }

    func testFilterCharactersBySeason() {

        let characters: [Actor] = [
            Actor(name: "Walter White", appearance: [1,2,3,4,5]),
            Actor(name: "Skyler White", appearance: [1,2,3,4,5]),
            Actor(name: "Mike Ehrmantraut", appearance: [2,3,4,5])
        ]

        let state = CharacterListState(
            searchText: "",
            loadedCharacters: characters,
            filteredCharacters: characters,
            seasonAppearanceSelected: 0
        )

        assert(initialValue: state,
               reducer: characterListReducer,
               steps:
            Step(.send, .seasonAppearance(1)) {
                $0.seasonAppeanceSelected = 1
                $0.filteredCharacters = [
                    Actor(name: "Walter White", appearance: [1,2,3,4,5]),
                    Actor(name: "Skyler White", appearance: [1,2,3,4,5])
                ]
            },
               Step(.send, .seasonAppearance(0)) {
                $0.seasonAppeanceSelected = 0
                $0.filteredCharacters = characters
            },
               Step(.send, .seasonAppearance(2)) {
                $0.seasonAppeanceSelected = 2
                $0.filteredCharacters = characters
            }
        )
    }

    func testCharacterFilters() {

        let characters: [Actor] = [
            Actor(name: "Walter White", appearance: [1,2,3,4,5]),
            Actor(name: "Skyler White", appearance: [1,2,3,4,5]),
            Actor(name: "Mike Ehrmantraut", appearance: [2,3,4,5])
        ]

        let state = CharacterListState(
            searchText: "Wh",
            loadedCharacters: characters,
            filteredCharacters: characters,
            seasonAppearanceSelected: 0
        )


        assert(initialValue: state,
               reducer: characterListReducer,
               steps:
            Step(.send, .seasonAppearance(1)) {
                $0.seasonAppeanceSelected = 1
                $0.searchText = "Wh"
                $0.filteredCharacters = [
                    Actor(name: "Walter White", appearance: [1,2,3,4,5]),
                    Actor(name: "Skyler White", appearance: [1,2,3,4,5])
                ]
            },
               Step(.send, .searchText("Wa")) {
                $0.seasonAppeanceSelected = 1
                $0.searchText = "Wa"
                $0.filteredCharacters = [
                    Actor(name: "Walter White", appearance: [1,2,3,4,5])
                ]
            },

               Step(.send, .searchText("ke")) {
                $0.seasonAppeanceSelected = 1
                $0.searchText = "ke"
                $0.filteredCharacters = [
                ]
            },
               Step(.send, .seasonAppearance(2)) {
                $0.seasonAppeanceSelected = 2
                $0.searchText = "ke"
                $0.filteredCharacters = [
                    Actor(name: "Mike Ehrmantraut", appearance: [2,3,4,5])
                ]
            }

        )

    }
}
