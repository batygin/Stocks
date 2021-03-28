import UIKit

class StocksListTableViewController: UITableViewController, QuoteCellDelegate {
    
    @IBOutlet var favoriteSegmentedControl: UISegmentedControl!
    
    func favoriteTapped(sender: QuoteCell) {
        guard var matchItem = items.first(where: { $0.id == sender.quotes?.id} ) else { return }
        guard let indexItem = items.firstIndex(where: { $0.id == sender.quotes?.id} ) else { return }
        matchItem.favorite.toggle()
        items[indexItem] = matchItem
        
        favoriteItems = items.filter { $0.favorite }
        tableView.reloadData()
    }
    
    let quotesItemController = QuotesItemController()
    
    var items = [Quotes]()
    var favoriteItems = [Quotes]()

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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
            self.tableView.reloadData()
    }
    
}
