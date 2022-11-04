import UIKit

class NumberCell: UITableViewCell {
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var no1: UILabel!
    @IBOutlet weak var no2: UILabel!
    @IBOutlet weak var no3: UILabel!
    @IBOutlet weak var no4: UILabel!
    @IBOutlet weak var no5: UILabel!
    @IBOutlet weak var no6: UILabel!
    @IBOutlet weak var bonusNo: UILabel!
    @IBOutlet weak var winCount: UILabel!
    @IBOutlet weak var winAmount: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    var detailButtonHandler: (() -> Void)?
    
    @IBAction func detailButton(_ sender: Any) {
        detailButtonHandler?()
    }
}

class NumberCloseCell: UITableViewCell {
    @IBOutlet weak var drwNo: UILabel!
    @IBOutlet weak var status: UIImageView!
}
