import UIKit
import Alamofire

class SearchLotteryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        naviConfigure()
    }
    
    func naviConfigure() {
        let backButton = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        backButton.image = UIImage(named: "6351950_arrow_back_direction_left_right_icon")
        backButton.tintColor = .darkGray
        
        let width = UIScreen.main.bounds.size.width
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 20, height: 0))
        searchBar.placeholder = "회차 입력"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

}
