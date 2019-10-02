
import UIKit

class TransationHistoryCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var recipetLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    func setup(recipet: String)  {
        idLabel.text = "ID: #1"
        balanceLabel.text = "\(100) KD"
        recipetLabel.text = "\(recipet)"
    }
}
