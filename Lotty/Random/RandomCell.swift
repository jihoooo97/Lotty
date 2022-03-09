import UIKit

class RandomCell: UITableViewCell {
    @IBOutlet weak var drwtNo1: UILabel!
    @IBOutlet weak var drwtNo2: UILabel!
    @IBOutlet weak var drwtNo3: UILabel!
    @IBOutlet weak var drwtNo4: UILabel!
    @IBOutlet weak var drwtNo5: UILabel!
    @IBOutlet weak var drwtNo6: UILabel!
    @IBOutlet weak var bnusNo: UILabel!
    
    var deleteButtonHandler: (() -> Void) = {}
    
    @IBAction func deleteButton(_ sender: Any) {
        deleteButtonHandler()
    }
}
