//
//  MarvelRequestBuilder.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

struct MarvelRequestBuilder {
    static func characters(offset: Int) -> MarvelRequestBuilder {
        let ts = String(Int(Date().timeIntervalSince1970))
        let hash = "\(ts)\(AppConstants.MarvelAPI.privateKey)\(AppConstants.MarvelAPI.publicKey)".md5
        let query: [String: String] = [
            "apikey": AppConstants.MarvelAPI.publicKey,
            "ts": ts,
            "hash": hash,
            "offset": "\(offset)"
        ]
        return MarvelRequestBuilder(path: "/characters", query: query)
    }
    
    private let path: String
    private let query: [String: String]
    
    func buildRequest() -> URLRequest? {
        var components = URLComponents(string: "https://gateway.marvel.com:443/v1/public\(path)")
        components?.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = components?.url else { return nil }
        return URLRequest(url: url)
    }
}
