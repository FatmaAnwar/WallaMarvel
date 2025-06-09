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
    
    func getHeroes() async {
        guard !isLoading else { return }
        isLoading = true
        
        delegate?.showLoading(true)
        
        do {
            let characters = try await getHeroesUseCase.execute(offset: currentOffset)
            currentOffset += characters.count
            allHeroes += characters
            
            let viewModels = allHeroes.map { HeroCellViewModel(from: $0) }
            delegate?.update(heroes: viewModels)
        } catch {
            print("Failed to load heroes:", error.localizedDescription)
        }
        
        delegate?.showLoading(false)
        isLoading = false
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
            Task {
                await getHeroes()
            }
        }
    }
}
