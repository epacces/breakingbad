//
//  AppLifecycleTests.swift
//  AppLifecycleTests
//
//  Created by Eriprando Pacces on 15/09/2020.
//  Copyright © 2020 Eriprando Pacces. All rights reserved.
//

import XCTest
import SwiftReduxTestSupport
@testable import AppLifecycle
import Model


class AppLifecycleTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Current = .mock
    }

    func testLoadCharacters() {

        let expectedChars = [
            Actor(name: "Walter"),
            Actor(name: "Jessy")
        ]
        Current.characters = {
            .sync(work: { expectedChars })
        }

        assert(initialValue: .idle,
               reducer: appLifecycleReducer,
               steps:
            Step(.send, .loadCharacters, { $0 = .loadingData }),
            Step(.receive, .charactersResponse(expectedChars), { $0 = .loadedData(expectedChars) })
        )

    }
}
