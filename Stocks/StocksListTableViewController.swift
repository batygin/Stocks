import UIKit

class StocksListTableViewController: UITableViewController {
    
    @IBOutlet var favoriteSegmentedControl: UISegmentedControl!
    
    let quotesItemController = QuotesItemController()
    let searchController = UISearchController(searchResultsController: nil)
    
    var items = [Quotes]()
    var favoriteItems = [Quotes]()
    var filteredItems = [Quotes]()
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        quotesItemController.fetchItems { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let quotes):
                    self.items = quotes
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredItems.count
        }
        
        let selectedIndex = self.favoriteSegmentedControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            return items.count
        case 1:
            return favoriteItems.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! QuoteCell
        
        if isFiltering {
            let item = filteredItems[indexPath.row]
            cell.update(with: item)
            cell.delegate = self
            return cell
        }
        
        let selectedIndex = favoriteSegmentedControl.selectedSegmentIndex
        switch selectedIndex {
        case 0:
            let item = items[indexPath.row]
            cell.update(with: item)
            cell.delegate = self
            return cell
        case 1:
            let item = favoriteItems[indexPath.row]
            cell.update(with: item)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func favoriteSegmentedTapped(_ sender: UISegmentedControl) {
        
        if isFiltering {
            updateSearchResults(for: searchController)
        }
        self.tableView.reloadData()
    }
    
    func filterContentForSearchText(_ searchText: String) {

        let selectedIndex = favoriteSegmentedControl.selectedSegmentIndex
        if selectedIndex == 0 {
            filteredItems = items.filter { (quote: Quotes) -> Bool in
              return quote.name.lowercased().contains(searchText.lowercased()) || quote.corp.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredItems = favoriteItems.filter { (quote: Quotes) -> Bool in
              return quote.name.lowercased().contains(searchText.lowercased()) || quote.corp.lowercased().contains(searchText.lowercased())
            }
        }
      tableView.reloadData()
    }

}

extension StocksListTableViewController: QuoteCellDelegate, UISearchResultsUpdating {
    
    func favoriteTapped(sender: QuoteCell) {
        guard var matchItem = items.first(where: { $0.id == sender.quotes?.id} ) else { return }
        guard let indexItem = items.firstIndex(where: { $0.id == sender.quotes?.id} ) else { return }
        matchItem.favorite.toggle()
        items[indexItem] = matchItem
        
        if isFiltering {
            updateSearchResults(for: searchController)
        }
        
        favoriteItems = items.filter { $0.favorite }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
}
