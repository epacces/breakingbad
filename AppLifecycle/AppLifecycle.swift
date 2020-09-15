
import Foundation
import Combine
import Model
import SwiftRedux

public enum AppLifecycleAction: Equatable {
    case loadCharacters
    case charactersResponse([Actor])

}

public enum AppLifecycleState: Equatable {
    case idle
    case loadingData
    case loadedData([Actor])
}

public var Current = Environment.live

public struct Environment {
    public var characters: () -> Effect<[Actor]>
}


public extension Environment {
    static let live = Environment(characters: {
        charactersPublisher.eraseToEffect()
    })
}

public extension Environment {
     static let mock = Environment(characters: {
        .sync(work: { [
            Actor(name: "Walter White"),
            Actor(name: "Skyler White")
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
        try JSONDecoder().decode([Actor].self, from: $0)
}
.replaceError(with: [])
.receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()

