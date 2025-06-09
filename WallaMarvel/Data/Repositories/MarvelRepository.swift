import Foundation

protocol MarvelRepositoryProtocol {
    func getHeroes(offset: Int, completionBlock: @escaping (Result<CharacterDataContainer, Error>) -> Void)
}

final class MarvelRepository: MarvelRepositoryProtocol {
    private let dataSource: MarvelRemoteDataSourceProtocol
    
    init(dataSource: MarvelRemoteDataSourceProtocol = MarvelRemoteDataSource()) {
        self.dataSource = dataSource
    }
    
    func getHeroes(offset: Int, completionBlock: @escaping (Result<CharacterDataContainer, Error>) -> Void) {
        dataSource.getHeroes(offset: offset, completionBlock: completionBlock)
    }
}
