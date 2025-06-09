//
//  ListHeroesViewModelProtocol.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 09/06/2025.
//

import Foundation

protocol ListHeroesViewModelProtocol: AnyObject {
    var delegate: ListHeroesViewModelDelegate? { get set }
    func screenTitle() -> String
    func getHeroes()
    func searchHeroes(with text: String)
    func didScrollToBottom(currentOffsetY: CGFloat, contentHeight: CGFloat, scrollViewHeight: CGFloat)
}
