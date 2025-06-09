import Foundation

protocol GetHeroesUseCaseProtocol {
    func execute(offset: Int, completionBlock: @escaping (Result<CharacterDataContainer, Error>) -> Void)
}

struct GetHeroes: GetHeroesUseCaseProtocol {
    private let repository: MarvelRepositoryProtocol
    
    init(repository: MarvelRepositoryProtocol = MarvelRepository()) {
        self.repository = repository
    }
    
    func execute(offset: Int, completionBlock: @escaping (Result<CharacterDataContainer, Error>) -> Void) {
        repository.getHeroes(offset: offset, completionBlock: completionBlock)
    }
}
