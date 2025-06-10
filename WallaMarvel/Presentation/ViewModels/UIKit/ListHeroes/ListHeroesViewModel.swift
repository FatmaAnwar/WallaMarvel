//
//  ListHeroesViewModel.swift
//  WallaMarvel
//
//  Created by Fatma Anwar on 10/06/2025.
//

import Foundation
import UIKit

final class ListHeroesViewModel: ListHeroesViewModelProtocol {
    weak var delegate: ListHeroesViewModelDelegate?
    private let sharedViewModel = SharedHeroesListViewModel()
    
    func screenTitle() -> String {
        "List of Heroes"
    }
    
    func getHeroes() async {
        delegate?.showLoading(true)
        do {
            let viewModels = try await sharedViewModel.fetchMoreHeroes()
            delegate?.update(heroes: viewModels)
        } catch {
            print("Error fetching heroes:", error)
        }
        delegate?.showLoading(false)
    }
    
    func searchHeroes(with text: String) {
        let viewModels = sharedViewModel.searchHeroes(text)
        delegate?.update(heroes: viewModels)
    }
    
    func didScrollToBottom(currentOffsetY: CGFloat, contentHeight: CGFloat, scrollViewHeight: CGFloat) {
        let threshold: CGFloat = 100.0
        if currentOffsetY > (contentHeight - scrollViewHeight - threshold) {
            Task {
                await getHeroes()
            }
        }
    }
}
