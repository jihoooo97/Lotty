import UIKit

class HistoryCell: UITableViewCell {
    @IBOutlet weak var drwNo: UILabel!
    @IBOutlet weak var clockImage: UIImageView!
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var clickButtonHandler: (() -> Void)?
    var deleteButtonHandler: (() -> Void)?
    
    @IBAction func clickButton(_ sender: Any) {
        clickButtonHandler?()
    }
    @IBAction func deleteButton(_ sender: Any) {
        deleteButtonHandler?()
    }
}
