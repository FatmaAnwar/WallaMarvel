//
//  MarvelAPIClient.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

final class MarvelAPIClient: MarvelAPIClientProtocol {
    func getHeroes(offset: Int) async throws -> CharacterDataContainer {
        guard let request = MarvelRequestBuilder.characters(offset: offset).buildRequest() else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let wrapper = try JSONDecoder().decode(CharacterResponseDataModel.self, from: data)
            return wrapper.data
        } catch {
            throw NetworkError.decodingError
        }
    }
}
