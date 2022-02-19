import UIKit
import Alamofire

class SearchLotteryViewController: UIViewController {
    @IBOutlet weak var no1: UILabel!
    @IBOutlet weak var no2: UILabel!
    @IBOutlet weak var no3: UILabel!
    @IBOutlet weak var no4: UILabel!
    @IBOutlet weak var no5: UILabel!
    @IBOutlet weak var no6: UILabel!
    @IBOutlet weak var bonusNo: UILabel!
    
    var drwtNo1 = ""
    var drwtNo2 = ""
    var drwtNo3 = ""
    var drwtNo4 = ""
    var drwtNo5 = ""
    var drwtNo6 = ""
    var bnusNo = ""
    
    var lottoNumber: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviConfigure()
        lotteryConfigure()
    }

    func naviConfigure() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "6351950_arrow_back_direction_left_right_icon"), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        backButton.tintColor = .darkGray
        backButton.sizeToFit()
        
        let width = UIScreen.main.bounds.size.width
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - 20, height: 0))
        searchBar.placeholder = "회차 입력"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    // present방식 생각해보기
    @objc func back() {
        print(self)
        self.dismiss(animated: true, completion: nil)
        //self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func lotteryConfigure() {
        no1.text = drwtNo1
        no2.text = drwtNo2
        no3.text = drwtNo3
        no4.text = drwtNo4
        no5.text = drwtNo5
        no6.text = drwtNo6
        bonusNo.text = bnusNo
        
        setRound(label: no1)
        setRound(label: no2)
        setRound(label: no3)
        setRound(label: no4)
        setRound(label: no5)
        setRound(label: no6)
        setRound(label: bonusNo)
    }
    
    func setRound(label: UILabel) {
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        if Int(label.text!)! <= 10 {
            label.backgroundColor = .firstColor
        } else if Int(label.text!)! <= 20 {
            label.backgroundColor = .secondColor
        } else if Int(label.text!)! <= 30 {
            label.backgroundColor = .thirdColor
        } else if Int(label.text!)! <= 40 {
            label.backgroundColor = .fourthColor
        } else {
            label.backgroundColor = .fifthColor
        }
    }
}

class ResultView: UIView {
    
}
