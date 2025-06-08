import Foundation

protocol ListHeroesPresenterProtocol: AnyObject {
    var ui: ListHeroesUI? { get set }
    func screenTitle() -> String
    func getHeroes()
}

protocol ListHeroesUI: AnyObject {
    func update(heroes: [CharacterDataModel])
}

final class ListHeroesPresenter: ListHeroesPresenterProtocol {
    var ui: ListHeroesUI?
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    
    private var currentOffset = 0
    private var isLoading = false
    private var allHeroes: [CharacterDataModel] = []
    
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
        
        getHeroesUseCase.execute(offset: currentOffset) { container in
            self.currentOffset += container.count
            self.allHeroes += container.characters
            self.ui?.update(heroes: self.allHeroes)
            self.isLoading = false
        }
    }
}

