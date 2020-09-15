import Foundation

public struct Actor: Decodable {
    public var id: Int
    public var name: String
    public var image: URL
    public var appearance: [Int]
    public var status: String
    public var nickname: String
    public var occupation: [String]

    enum CodingKeys: String, CodingKey {
        case id = "char_id"
        case name
        case image = "img"
        case appearance
        case status
        case occupation
        case nickname
    }

    public init(
        id: Int = 0,
        name: String = "",
        image: URL = URL(string: "https://cast_bb_700x1000_mike-ehrmantraut-lg.jpg")!,
        appearance: [Int] = [],
        status: String = "",
        nickname: String = "",
        occupation: [String] = []
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.appearance = appearance
        self.status = status
        self.nickname = nickname
        self.occupation = occupation
    }
}


extension Actor: Equatable { }

