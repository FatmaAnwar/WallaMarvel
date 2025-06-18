//
//  HeroCellViewModelProtocol.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 13/06/2025.
//

import Foundation

protocol HeroCellViewModelProtocol: Identifiable where ID == Int {
    var name: String { get }
    var imageURL: URL? { get }
}
