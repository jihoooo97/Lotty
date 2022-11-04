import UIKit

class LocationHistoryCell: UITableViewCell {
    @IBOutlet weak var locationLabel: UILabel!
    
    var clickButtonHandler: (() -> Void)?
    var deleteButtonHandler: (() -> Void)?
    
    @IBAction func clickButton(_ sender: Any) {
        clickButtonHandler?()
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        deleteButtonHandler?()
    }
}
