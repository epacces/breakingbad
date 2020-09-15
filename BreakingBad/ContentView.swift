import SwiftUI
import SwiftRedux
import Model
import CharacterList
import Model
import AppLifecycle


enum AppAction {
    case appLifecycle(AppLifecycleAction)
    case characterList(CharacterListAction)
}


extension AppState {
    var appLifecycle: AppLifecycleState {
        get {
            return isLoadingCharacters ? .loadingData : .loadedData(loadedCharacters)
        }
        set {
            switch newValue {
            case .loadingData, .idle:
                isLoadingCharacters = true
                loadedCharacters = []
                filteredCharacters = []
            case let .loadedData(chars):
                isLoadingCharacters = false
                loadedCharacters = chars
                filteredCharacters = chars
            }
        }
    }
}

extension AppAction {
    var appLifecycle: AppLifecycleAction? {
        get {
            guard case let .appLifecycle(value) = self else { return nil }
            return value
        }
        set {
            guard case .appLifecycle = self, let newValue = newValue else { return }
            self = .appLifecycle(newValue)
        }
    }
}

extension AppState {
    var characterList: CharacterListState {
        get {
            CharacterListState(
                searchText: searchText,
                loadedCharacters: loadedCharacters,
                filteredCharacters: filteredCharacters
            )
        }
        set {
            searchText = newValue.searchText
            loadedCharacters = newValue.loadedCharacters
            filteredCharacters = newValue.filteredCharacters
        }
    }


}

extension AppAction {
    var characterList: CharacterListAction? {
        get {
            guard case let .characterList(value) = self else { return nil }
            return value
        }
        set {
            guard case .characterList = self, let newValue = newValue else { return }
            self = .characterList(newValue)
        }
    }
}


let appReducer = combine(
    pullback(appLifecycleReducer,
             value: \AppState.appLifecycle,
             action: \AppAction.appLifecycle),
    pullback(characterListReducer,
             value: \.characterList,
             action: \.characterList)

)


struct ContentView: View {

    @ObservedObject var store: Store<AppState, AppAction>

    init(store: Store<AppState, AppAction>) {
        self.store = store
        store.send(.appLifecycle(.loadCharacters))
    }

    var body: some View {
        CharacterListView(store: store.view(value: { $0.characterList }, action: { .characterList($0) }))
    }
}
