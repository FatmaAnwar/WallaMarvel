//
//  MarvelAPIClient.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

final class MarvelAPIClient: MarvelAPIClientProtocol {
    
    func getHeroes(offset: Int, completionBlock: @escaping (Result<CharacterDataContainer, Error>) -> Void) {
        guard let request = MarvelRequestBuilder.characters(offset: offset).buildRequest() else {
            completionBlock(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completionBlock(.failure(error))
                return
            }
            
            guard let data = data else {
                completionBlock(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(CharacterDataContainer.self, from: data)
                completionBlock(.success(decoded))
            } catch {
                completionBlock(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}
