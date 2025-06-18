import Foundation

struct Thumbnail: Codable, Sendable {
    let path: String
    let `extension`: String

    var fullPath: String {
        return "\(path).\(self.extension)"
    }
}
