//
//  ModelTests.swift
//  ModelTests
//
//  Created by Eriprando Pacces on 15/09/2020.
//  Copyright © 2020 Eriprando Pacces. All rights reserved.
//

import XCTest
@testable import Model

class ModelTests: XCTestCase {

    func testJSONParsing() {

        let json = """
        {
               "char_id": 3,
               "name": "Skyler White",
               "birthday": "08-11-1970",
               "occupation": [
                   "House wife",
                   "Book Keeper",
                   "Car Wash Manager",
                   "Taxi Dispatcher"
               ],
               "img": "https://s-i.huffpost.com/gen/1317262/images/o-ANNA-GUNN-facebook.jpg",
               "status": "Alive",
               "nickname": "Sky",
               "appearance": [
                   1,
                   2,
                   3,
                   4,
                   5
               ],
               "portrayed": "Anna Gunn",
               "category": "Breaking Bad",
               "better_call_saul_appearance": []
           }
        """.data(using: .utf8)!

        XCTAssertNoThrow(try JSONDecoder().decode(Character.self, from: json))

        let expected = Character(
            id: 3,
            name: "Skyler White",
            image: URL(string: "https://s-i.huffpost.com/gen/1317262/images/o-ANNA-GUNN-facebook.jpg")!,
            appearance: [1,2,3,4,5],
            status: "Alive",
            nickname: "Sky",
            occupation: ["House wife", "Book Keeper", "Car Wash Manager", "Taxi Dispatcher"]
        )

        XCTAssertEqual(expected,
                       try! JSONDecoder().decode(Character.self, from: json))
        
    }
}
