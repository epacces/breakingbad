
import Foundation
import Combine
import Model
import SwiftRedux

public enum AppLifecycleAction: Equatable {
    case loadCharacters
    case charactersResponse([Character])

}

public enum AppLifecycleState: Equatable {
    case idle
    case loadingData
    case loadedData([Character])
}

public var Current = Environment.live

public struct Environment {
    public var characters: () -> Effect<[Character]>
}


public extension Environment {
    static let live = Environment(characters: {
        charactersPublisher.eraseToEffect()
    })
}

public extension Environment {
     static let mock = Environment(characters: {
        .sync(work: { [
            Character(name: "Walter White"),
            Character(name: "Skyler White")
            ]}
        )
      })
}

public func appLifecycleReducer(state: inout AppLifecycleState, action: AppLifecycleAction) -> [Effect<AppLifecycleAction>] {

    switch action {
    case .loadCharacters:
        state = .loadingData
        return [
            Current.characters()
                .map(AppLifecycleAction.charactersResponse)
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
        ]

    case let .charactersResponse(characters):
        state = .loadedData(characters)
        return []
    }
}

let charactersPublisher =  URLSession.shared.dataTaskPublisher(for: URL(string: "https://breakingbadapi.com/api/characters")!)
    .map(\.data)
    .tryMap {
        try JSONDecoder().decode([Character].self, from: $0)
}
.replaceError(with: [])
.receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()

