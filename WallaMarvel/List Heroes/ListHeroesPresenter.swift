import Foundation

protocol ListHeroesPresenterProtocol: AnyObject {
    var ui: ListHeroesUI? { get set }
    func screenTitle() -> String
    func getHeroes()
    func searchHeroes(with text: String)
}

protocol ListHeroesUI: AnyObject {
    func update(heroes: [CharacterDataModel])
    func showLoading(_ show: Bool)
}

final class ListHeroesPresenter: ListHeroesPresenterProtocol {
    var ui: ListHeroesUI?
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
            self.ui?.showLoading(true)
        }
        
        getHeroesUseCase.execute(offset: currentOffset) { container in
            self.currentOffset += container.count
            self.allHeroes += container.characters
            self.ui?.update(heroes: self.allHeroes)
            
            DispatchQueue.main.async {
                self.ui?.showLoading(false)
            }
            
            self.isLoading = false
        }
    }
    
    func searchHeroes(with text: String) {
        if text.isEmpty {
            ui?.update(heroes: allHeroes)
        } else {
            let result = allHeroes.filter { $0.name.lowercased().contains(text.lowercased()) }
            ui?.update(heroes: result)
        }
    }
}
