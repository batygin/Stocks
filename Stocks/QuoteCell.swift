import UIKit

protocol QuoteCellDelegate: AnyObject {
    func favoriteTapped(sender: QuoteCell)
}

class QuoteCell: UITableViewCell {
    weak var delegate: QuoteCellDelegate?
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var corpLabel: UILabel!
    @IBOutlet var trendLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    var quotes: Quotes?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(with quotes: Quotes) {
        nameLabel.text = quotes.name
        priceLabel.text = NSString(format: "$%.2f", quotes.price) as String
        corpLabel.text = quotes.corp
        trendLabel.text = NSString(format: "%.2f", quotes.trend) as String
        favoriteButton.isSelected = quotes.favorite
        
        if quotes.trend > 0 {
            trendLabel.textColor = UIColor.systemGreen
        } else if quotes.trend < 0 {
            trendLabel.textColor = UIColor.systemRed
        }
        
        self.quotes = quotes
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        delegate?.favoriteTapped(sender: self)
    }
}
