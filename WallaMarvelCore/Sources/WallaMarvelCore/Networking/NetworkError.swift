//
//  NetworkError.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingError
}
