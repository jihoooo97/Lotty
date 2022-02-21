import UIKit
import Alamofire

class SearchLotteryViewController: UIViewController {
    @IBOutlet weak var lotteryView: UIView!
    @IBOutlet weak var drwNo: UILabel!
    @IBOutlet weak var drwDate: UILabel!
    @IBOutlet weak var no1: UILabel!
    @IBOutlet weak var no2: UILabel!
    @IBOutlet weak var no3: UILabel!
    @IBOutlet weak var no4: UILabel!
    @IBOutlet weak var no5: UILabel!
    @IBOutlet weak var no6: UILabel!
    @IBOutlet weak var bonusNo: UILabel!
    @IBOutlet weak var winCount: UILabel!
    @IBOutlet weak var winAmount: UILabel!
    @IBOutlet weak var totalWinAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var searchHistory: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var historyTableViewTop: NSLayoutConstraint!
    
    var lotteryInfo = LotteryInfo(drwNoDate: "", drwNo: 0, firstAccumamnt: 0, firstWinamnt: 0, firstPrzwnerCo: 0, drwtNo1: 0, drwtNo2: 0, drwtNo3: 0, drwtNo4: 0, drwtNo5: 0, drwtNo6: 0, bnusNo: 0, returnValue: "", totSellamnt: 0)
    var searchHistoryList = Storage.retrive("search_history.json", from: .documents, as: [Int].self) ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviConfigure()
        self.tabBarController?.tabBar.isHidden = true
        historyTableView.dataSource = self
        historyTableView.delegate = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearButton.imageView?.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        if lotteryInfo.drwNoDate != "" {
            lotteryConfigure()
        } else {
            lotteryView.isHidden = true
            if lotteryView.isHidden {
                historyTableViewTop.constant = 20
            }
        }
    }
    
    func naviConfigure() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "arrow_left_icon"), for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        backButton.tintColor = .darkGray
        backButton.sizeToFit()
        
        let width = UIScreen.main.bounds.size.width
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - backButton.frame.width * 3, height: 0))
        searchBar.placeholder = "회차 입력"
        searchBar.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    // present방식 생각해보기
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func lotteryConfigure() {
        drwNo.text = "\(lotteryInfo.drwNo)회"
        drwDate.text = lotteryInfo.drwNoDate
        no1.text = "\(lotteryInfo.drwtNo1)"
        no2.text = "\(lotteryInfo.drwtNo2)"
        no3.text = "\(lotteryInfo.drwtNo3)"
        no4.text = "\(lotteryInfo.drwtNo4)"
        no5.text = "\(lotteryInfo.drwtNo5)"
        no6.text = "\(lotteryInfo.drwtNo6)"
        bonusNo.text = "\(lotteryInfo.bnusNo)"
        winCount.text = "\(lotteryInfo.firstPrzwnerCo)명"
        winAmount.text = "\(numberFormatter(number: lotteryInfo.firstWinamnt))원"
        totalWinAmount.text = "\(numberFormatter(number: lotteryInfo.firstAccumamnt))원"
        totalAmount.text = "\(numberFormatter(number: lotteryInfo.totSellamnt))원"
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
        label.layer.cornerRadius = 18
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
    
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    @IBAction func clearHistoy(_ sender: Any) {
        let alert = UIAlertController(title: "알림", message: "최근 조회 목록을 모두 삭제하시겠습니까?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { action in
            self.searchHistoryList = []
            Storage.clear(.documents)
            self.historyTableView.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @IBAction func tapView(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.customView?.resignFirstResponder()
    }
}

extension SearchLotteryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let parameters: Parameters = [
            "method": "getLottoNumber",
            "drwNo": searchBar.text!
        ]
        AF.request("https://www.dhlottery.co.kr/common.do", method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate(statusCode: 200..<300).responseDecodable(of: LotteryInfo.self) { response in
            switch response.result {
            case .success:
                self.lotteryView.isHidden = false
                self.historyTableViewTop.constant = self.lotteryView.frame.height + 20
                searchBar.text = ""
                guard let lottery = response.value else { return }
                self.lotteryInfo = lottery
                self.lotteryConfigure()
                self.searchHistoryList = self.searchHistoryList.filter { $0 != lottery.drwNo }
                self.searchHistoryList.insert(lottery.drwNo, at: 0)
                Storage.store(self.searchHistoryList, to: .documents, as: "search_history.json")
                self.historyTableView.reloadData()
            case .failure:
                return
            }
        }
    }
}

extension SearchLotteryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return searchHistoryList.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryCell else { return UITableViewCell() }
        cell.drwNo.text = "\(searchHistoryList[indexPath.row])회"
        cell.deleteButtonHandler = {
            self.searchHistoryList.remove(at: indexPath.row)
            Storage.store(self.searchHistoryList, to: .documents, as: "search_history.json")
            self.historyTableView.reloadData()
        }
        
        return cell
    }
    
}

extension SearchLotteryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationItem.rightBarButtonItem?.customView?.resignFirstResponder()
        let parameters: Parameters = [
            "method": "getLottoNumber",
            "drwNo": searchHistoryList[indexPath.row]
        ]
        AF.request("https://www.dhlottery.co.kr/common.do", method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate(statusCode: 200..<300).responseDecodable(of: LotteryInfo.self) { response in
            switch response.result {
            case .success:
                if self.lotteryView.isHidden {
                    self.lotteryView.isHidden = false
                    self.historyTableViewTop.constant = self.lotteryView.frame.height + 20
                }
                guard let lottery = response.value else { return }
                self.lotteryInfo = lottery
                self.lotteryConfigure()
                self.searchHistoryList.remove(at: indexPath.row)
                self.searchHistoryList.insert(lottery.drwNo, at: 0)
                Storage.store(self.searchHistoryList, to: .documents, as: "search_history.json")
                self.historyTableView.reloadData()
            case .failure:
                return
            }
        }
    }
}

class HistoryCell: UITableViewCell {
    @IBOutlet weak var drwNo: UILabel!
    @IBOutlet weak var clockImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var deleteButtonHandler: (() -> Void)?
    
    @IBAction func deleteButton(_ sender: Any) {
        deleteButtonHandler?()
    }
}
