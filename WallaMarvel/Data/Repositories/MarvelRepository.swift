import Foundation

protocol MarvelRepositoryProtocol {
    func getHeroes(offset: Int, completionBlock: @escaping (Result<[Character], Error>) -> Void)
}

final class MarvelRepository: MarvelRepositoryProtocol {
    private let dataSource: MarvelRemoteDataSourceProtocol
    
    init(dataSource: MarvelRemoteDataSourceProtocol = MarvelRemoteDataSource()) {
        self.dataSource = dataSource
    }
    
    func getHeroes(offset: Int, completionBlock: @escaping (Result<[Character], Error>) -> Void) {
        dataSource.getHeroes(offset: offset) { result in
            switch result {
            case .success(let container):
                let characters = CharacterMapper.map(from: container)
                completionBlock(.success(characters))
            case .failure(let error):
                completionBlock(.failure(error))
            }
        }
    }
}
