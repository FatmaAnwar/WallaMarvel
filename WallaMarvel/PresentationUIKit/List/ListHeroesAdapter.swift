import Foundation
import UIKit

final class ListHeroesAdapter: NSObject {
    var heroCellViewModels: [HeroCellViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var onHeroSelected: ((HeroCellViewModel) -> Void)?
    
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ListHeroesAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        heroCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListHeroesTableViewCell", for: indexPath) as! ListHeroesTableViewCell
        let viewModel = heroCellViewModels[indexPath.row]
        cell.configure(viewModel: viewModel)
        return cell
    }
}

extension ListHeroesAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = heroCellViewModels[indexPath.row]
        onHeroSelected?(selected)
    }
}
