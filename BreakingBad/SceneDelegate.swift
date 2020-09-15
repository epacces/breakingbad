//
//  SceneDelegate.swift
//  BreakingBad
//
//  Created by Eriprando Pacces on 12/09/2020.
//  Copyright © 2020 Eriprando Pacces. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import SwiftRedux

import Model

struct AppState {
    var isLoadingCharacters: Bool = false
    var loadedCharacters: [Character] = []
    var filteredCharacters: [Character] = []
    var searchText: String = ""
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            window.rootViewController = UIHostingController(
                rootView: ContentView(
                    store: Store(
                        initialValue: AppState(),
                        reducer: with(
                            appReducer,
                            logging
                        )
                    )
                )
            )
            self.window = window
            window.makeKeyAndVisible()
        }
    }

}

