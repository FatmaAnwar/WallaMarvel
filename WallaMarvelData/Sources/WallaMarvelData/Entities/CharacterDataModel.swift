import Foundation

public struct CharacterDataModel: Decodable {
    let id: Int
    let name: String
    let thumbnail: Thumbnail
    let description: String?
}
