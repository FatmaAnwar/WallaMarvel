import Foundation

protocol ListHeroesViewModelDelegate: AnyObject {
    func update(heroes: [HeroCellViewModel])
    func showLoading(_ show: Bool)
}

final class ListHeroesViewModel: ListHeroesViewModelProtocol {
    var delegate: ListHeroesViewModelDelegate?
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    
    private var currentOffset = 0
    private var isLoading = false
    private var allHeroes: [Character] = []
    private var filteredHeroes: [Character] = []
    
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
        
        getHeroesUseCase.execute(offset: currentOffset) { result in
            switch result {
            case .success(let characters):
                self.currentOffset += characters.count
                self.allHeroes += characters
                let viewModels = self.allHeroes.map { HeroCellViewModel(from: $0) }
                self.delegate?.update(heroes: viewModels)
                
            case .failure(let error):
                print("Failed to load heroes:", error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.delegate?.showLoading(false)
            }
            
            self.isLoading = false
        }
    }
    
    func searchHeroes(with text: String) {
        if text.isEmpty {
            let viewModels = self.allHeroes.map { HeroCellViewModel(from: $0) }
            self.delegate?.update(heroes: viewModels)
        } else {
            let result = allHeroes.filter { $0.name.lowercased().contains(text.lowercased()) }
            let viewModels = result.map { HeroCellViewModel(from: $0) }
            self.delegate?.update(heroes: viewModels)
        }
    }
    
    func didScrollToBottom(currentOffsetY: CGFloat, contentHeight: CGFloat, scrollViewHeight: CGFloat) {
        let threshold: CGFloat = 100.0
        if currentOffsetY > (contentHeight - scrollViewHeight - threshold) {
            getHeroes()
        }
    }
}
