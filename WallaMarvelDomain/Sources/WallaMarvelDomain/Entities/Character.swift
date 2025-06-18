//
//  Character.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

public struct Character: Hashable, Identifiable, Sendable {
    public let id: Int
    public let name: String
    public let imageUrl: String
    public let description: String

    public init(id: Int, name: String, imageUrl: String, description: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.description = description
    }
}
