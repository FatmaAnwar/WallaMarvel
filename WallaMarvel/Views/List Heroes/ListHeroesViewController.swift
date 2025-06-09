import UIKit

final class ListHeroesViewController: UIViewController {
    var mainView: ListHeroesView { return view as! ListHeroesView  }
    
    var viewModel: ListHeroesViewModelProtocol?
    var listHeroesProvider: ListHeroesAdapter?
    
    override func loadView() {
        view = ListHeroesView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listHeroesProvider = ListHeroesAdapter(tableView: mainView.heroesTableView)
        viewModel?.getHeroes()
        viewModel?.delegate = self
        
        title = viewModel?.screenTitle()
        
        mainView.heroesTableView.delegate = self
        mainView.searchBar.delegate = self
    }
}

extension ListHeroesViewController: ListHeroesViewModelDelegate {
    func update(heroes: [CharacterDataModel]) {
        listHeroesProvider?.heroes = heroes
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
        guard let selectedHero = listHeroesProvider?.heroes[indexPath.row] else { return }
        
        let detailVC = HeroDetailViewController()
        let presenter = HeroDetailPresenter(hero: selectedHero, ui: detailVC)
        detailVC.presenter = presenter
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if position > (contentHeight - scrollViewHeight - 100) {
            viewModel?.getHeroes()
        }
    }
}

extension ListHeroesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchHeroes(with: searchText)
    }
}
