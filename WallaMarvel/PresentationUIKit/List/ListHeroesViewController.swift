import UIKit

final class ListHeroesViewController: UIViewController {
    var viewModel: ListHeroesViewModelProtocol?
    var listHeroesProvider: ListHeroesAdapter?
    var onHeroSelected: ((HeroCellViewModel) -> Void)?
    
    var mainView: ListHeroesView {
        return view as! ListHeroesView
    }
    
    override func loadView() {
        view = ListHeroesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listHeroesProvider = ListHeroesAdapter(tableView: mainView.heroesTableView)
        listHeroesProvider?.onHeroSelected = { [weak self] heroCellViewModel in
            self?.onHeroSelected?(heroCellViewModel)
        }
        mainView.heroesTableView.delegate = self
        mainView.searchBar.delegate = self

        viewModel?.delegate = self
        title = viewModel?.screenTitle()

        Task {
            await viewModel?.getHeroes()
        }
    }
}

extension ListHeroesViewController: ListHeroesViewModelDelegate {
    func update(heroes: [HeroCellViewModel]) {
        listHeroesProvider?.heroCellViewModels = heroes
    }
    
    func showLoading(_ show: Bool) {
        DispatchQueue.main.async {
            show ? self.mainView.loadingIndicator.startAnimating()
            : self.mainView.loadingIndicator.stopAnimating()
        }
    }
}

extension ListHeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedHero = listHeroesProvider?.heroCellViewModels[indexPath.row] else { return }
        onHeroSelected?(selectedHero)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel?.didScrollToBottom(
            currentOffsetY: scrollView.contentOffset.y,
            contentHeight: scrollView.contentSize.height,
            scrollViewHeight: scrollView.frame.size.height
        )
    }
}

extension ListHeroesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchHeroes(with: searchText)
    }
}
