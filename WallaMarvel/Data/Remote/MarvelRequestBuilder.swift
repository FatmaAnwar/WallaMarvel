//
//  MarvelRequestBuilder.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

struct MarvelRequestBuilder {
    private let path: String
    private let query: [String: String]
    
    static func characters(offset: Int) -> MarvelRequestBuilder {
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let hashInput = "\(timestamp)\(AppConstants.MarvelAPI.privateKey)\(AppConstants.MarvelAPI.publicKey)"
        let hash = hashInput.md5
        
        let query: [String: String] = [
            "apikey": AppConstants.MarvelAPI.publicKey,
            "ts": timestamp,
            "hash": hash,
            "offset": "\(offset)"
        ]
        
        return MarvelRequestBuilder(path: AppConstants.MarvelAPI.charactersPath, query: query)
    }
    
    func buildRequest() -> URLRequest? {
        var components = URLComponents(string: "\(AppConstants.MarvelAPI.baseURL)\(path)")
        components?.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = components?.url else { return nil }
        return URLRequest(url: url)
    }
}

