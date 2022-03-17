import UIKit
import Alamofire
import AVFoundation

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var explainLabel: UILabel!
    
    private var refreshControl = UIRefreshControl()
    var lotteryArray: [LotteryItem] = []
    var searchHistoryList: [Int] = []
    var fetchingMore = false
    var recentNumber = 0
    var page = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailLottery" {
            let vc = segue.destination as! SearchLotteryViewController
            vc.lotteryInfo = sender as! LotteryInfo
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        configureNavi()
        
        recentNumber = getRecentNumber()
        for i in 0..<10 { getLotteryNumber(drwNo: recentNumber - i) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .white
        searchHistoryList = Storage.retrive("search_history.json", from: .documents, as: [Int].self) ?? []
    }
    
    func configureNavi() {
        self.title = "조회하기"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.G900,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        self.navigationController?.navigationBar.layoutMargins.left = 32
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // 글자 간격
        let attrString = NSMutableAttributedString(string: explainLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        explainLabel.attributedText = attrString
    }
    
    func getNowTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "ko-KR") as TimeZone?
        return formatter.string(from: now)
    }
    
    func getRecentNumber() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let base = 1002
        let now = getNowTime()
        
        guard let startTime = formatter.date(from: "2022-02-12 20:45:00") else { return 0 }
        guard let endTime = formatter.date(from: now) else { return 0 }
        
        let subTime = Int(endTime.timeIntervalSince(startTime)) / 60
        let count = subTime / 10080
        return base + count
    }
    
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    func getLotteryNumber(drwNo: Int) {
        let parameters: Parameters = [
            "method": "getLottoNumber",
            "drwNo": drwNo
        ]
        AF.request("https://www.dhlottery.co.kr/common.do", method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate(statusCode: 200..<300).responseDecodable(of: LotteryInfo.self) { response in
            switch response.result {
            case .success:
                guard let lottery = response.value else { return }
                if lottery.drwNo == self.recentNumber {
                    self.lotteryArray.append(LotteryItem(lottery: lottery, open: true))
                } else {
                    self.lotteryArray.append(LotteryItem(lottery: lottery))
                }
                self.lotteryArray.sort(by: { $0.lottery.drwNo > $1.lottery.drwNo })
                if self.lotteryArray.count == 20 {
                    self.tableView.reloadData()
                }
                
            case .failure:
//                AF.request("https://www.dhlottery.co.kr/common.do", method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate(statusCode: 200..<300).responseDecodable(of: LotteryFail.self) { response in
//                    switch response.result {
//                    case .success:
//                        guard let lottery = response.value else { return }
//                        print(lottery.returnValue)
//                        let item = LotteryInfo()
//                        self.lotteryArray.append(LotteryItem(lottery: LotteryInfo(), open: true))
//                    case .failure:
//                        return
//                    }
//                }
                return
            }
        }
    }
    
    @objc func pullToRefresh() {
        tableView.refreshControl?.endRefreshing()
        self.lotteryArray = []
        self.page = 0
        recentNumber = getRecentNumber()
        for i in 0..<10 { getLotteryNumber(drwNo: recentNumber - i) }
    }
}

// MARK: 테이블뷰 DataSource
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return lotteryArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lotteryArray[section].open == true { return 2 }
        else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "numberCloseCell", for: indexPath) as? NumberCloseCell else { return UITableViewCell() }
            if lotteryArray[indexPath.section].open == true {
                cell.status.image = UIImage(named: "arrow_up_icon")
            } else {
                cell.status.image = UIImage(named: "arrow_down_icon")
            }
            cell.drwNo.text = "\(lotteryArray[indexPath.section].lottery.drwNo)회"
            return cell
        } else {
            // 회차 리턴 없으면 failview
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "numberCell", for: indexPath) as? NumberCell else { return FailCell() }
            cell.date.text = lotteryArray[indexPath.section].lottery.drwNoDate
            cell.no1.text = "\(lotteryArray[indexPath.section].lottery.drwtNo1)"
            cell.no2.text = "\(lotteryArray[indexPath.section].lottery.drwtNo2)"
            cell.no3.text = "\(lotteryArray[indexPath.section].lottery.drwtNo3)"
            cell.no4.text = "\(lotteryArray[indexPath.section].lottery.drwtNo4)"
            cell.no5.text = "\(lotteryArray[indexPath.section].lottery.drwtNo5)"
            cell.no6.text = "\(lotteryArray[indexPath.section].lottery.drwtNo6)"
            cell.bonusNo.text = "\(lotteryArray[indexPath.section].lottery.bnusNo)"
            cell.winCount.text = "총 \(lotteryArray[indexPath.section].lottery.firstPrzwnerCo)명 당첨"
            cell.winAmount.text = numberFormatter(number: lotteryArray[indexPath.section].lottery.firstWinamnt)
            cell.detailButtonHandler = {
                self.searchHistoryList = self.searchHistoryList.filter { $0 != self.lotteryArray[indexPath.section].lottery.drwNo }
                self.searchHistoryList.insert(self.lotteryArray[indexPath.section].lottery.drwNo, at: 0)
                Storage.store(self.searchHistoryList, to: .documents, as: "search_history.json")
                self.performSegue(withIdentifier: "detailLottery", sender: self.lotteryArray[indexPath.section].lottery)
            }
            setRound(label: cell.no1)
            setRound(label: cell.no2)
            setRound(label: cell.no3)
            setRound(label: cell.no4)
            setRound(label: cell.no5)
            setRound(label: cell.no6)
            setRound(label: cell.bonusNo)
            return cell
        }
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
}

// MARK: 테이블뷰 Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return 50 }
        else { return 200 }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NumberCloseCell else { return }
        guard let index = tableView.indexPath(for: cell) else { return }
        
        if index.row == indexPath.row && index.row == 0 {
            if lotteryArray[indexPath.section].open == true {
                lotteryArray[indexPath.section].open = false
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            } else {
                lotteryArray[indexPath.section].open = true
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            }
        }
    }
}

// MARK: 테이블뷰 갱신
extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset_y = tableView.contentOffset.y
        let tableViewContentSize = tableView.contentSize.height
        let pagination_y = tableView.bounds.size.height
        
        if contentOffset_y > (tableViewContentSize - pagination_y) {
            if !fetchingMore { beingFetch() }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.tableView.reloadData()
    }
    
    // 무한 스크롤
    private func beingFetch() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.page += 1
            if self.recentNumber - (self.page * 10) > 10 {
                for i in 0..<10 { self.getLotteryNumber(drwNo: self.recentNumber - (self.page * 10 + i)) }
                self.fetchingMore = false
            }
        }
    }
}
