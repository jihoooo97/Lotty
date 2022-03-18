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
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var historyTableViewTop: NSLayoutConstraint!
    
    var lotteryInfo = LotteryInfo(drwNoDate: "", drwNo: 0, firstAccumamnt: 0, firstWinamnt: 0, firstPrzwnerCo: 0, drwtNo1: 0, drwtNo2: 0, drwtNo3: 0, drwtNo4: 0, drwtNo5: 0, drwtNo6: 0, bnusNo: 0, returnValue: "", totSellamnt: 0)
    var searchHistoryList: [Int] = []
    
    // [!] 전체 삭제 옆에 쓰레기통, 구분선 G100
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavi()
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        searchHistoryList = Storage.retrive("search_history.json", from: .documents, as: [Int].self) ?? []
        if lotteryInfo.drwNoDate != "" {
            lotteryConfigure()
        } else {
            
        }
        
        if lotteryView.isHidden {
            historyTableViewTop.constant = 0
        } else {
//            historyTableViewTop.constant = lotteryView.bounds.height
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        Storage.store(searchHistoryList, to: .documents, as: "search_history.json")
    }
    
    func configureNavi() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "arrow_left_icon"), for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        backButton.tintColor = .G900
        backButton.sizeToFit()
        
        let width = UIScreen.main.bounds.size.width
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width - backButton.frame.width * 3, height: 0))
        searchBar.tintColor = .G600
        searchBar.placeholder = "회차 입력"
        searchBar.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
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
                searchBar.text = ""
                guard let lottery = response.value else { return }
                self.lotteryInfo = lottery
                self.lotteryConfigure()
                self.searchHistoryList = self.searchHistoryList.filter { $0 != lottery.drwNo }
                self.searchHistoryList.insert(lottery.drwNo, at: 0)
                self.historyTableView.reloadData()
            case .failure:
                return
            }
        }
    }
}

extension SearchLotteryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchHistoryList.count > 0 {
            return searchHistoryList.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchHistoryList.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryCell else { return UITableViewCell() }
            cell.drwNo.text = "\(searchHistoryList[indexPath.row])회"
            cell.clickButtonHandler = {
                self.navigationItem.rightBarButtonItem?.customView?.resignFirstResponder()
                let parameters: Parameters = [
                    "method": "getLottoNumber",
                    "drwNo": self.searchHistoryList[indexPath.row]
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
                        self.historyTableView.reloadData()
                    case .failure:
                        return
                    }
                }
            }
            cell.deleteButtonHandler = {
                self.searchHistoryList.remove(at: indexPath.row)
                self.historyTableView.reloadData()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath) as? EmptyCell else { return UITableViewCell() }
            return cell
        }
    }
}

extension SearchLotteryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchHistoryList.count > 0 {
            return 50
        } else {
            return 150
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
