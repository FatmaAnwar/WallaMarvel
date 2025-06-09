import Foundation

protocol ListHeroesViewModelDelegate: AnyObject {
    func update(heroes: [CharacterDataModel])
    func showLoading(_ show: Bool)
}

final class ListHeroesViewModel: ListHeroesViewModelProtocol {
    var delegate: ListHeroesViewModelDelegate?
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    
    private var currentOffset = 0
    private var isLoading = false
    private var allHeroes: [CharacterDataModel] = []
    private var filteredHeroes: [CharacterDataModel] = []
    
    init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
        self.getHeroesUseCase = getHeroesUseCase
    }
    
    func screenTitle() -> String {
        "List of Heroes"
    }
    
    // MARK: UseCases
    
    func getHeroes() {
        guard !isLoading else { return }
        isLoading = true
        DispatchQueue.main.async {
            self.delegate?.showLoading(true)
        }
        
        getHeroesUseCase.execute(offset: currentOffset) { container in
            self.currentOffset += container.count
            self.allHeroes += container.characters
            self.delegate?.update(heroes: self.allHeroes)
            
            DispatchQueue.main.async {
                self.delegate?.showLoading(false)
            }
            
            self.isLoading = false
        }
    }
    
    func searchHeroes(with text: String) {
        if text.isEmpty {
            delegate?.update(heroes: allHeroes)
        } else {
            let result = allHeroes.filter { $0.name.lowercased().contains(text.lowercased()) }
            delegate?.update(heroes: result)
        }
    }
}
