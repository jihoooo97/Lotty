import UIKit
import Alamofire
import AVFoundation
import Network

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let monitor = NWPathMonitor()
    private var refreshControl = UIRefreshControl()
    
    var lotteryArray: [LotteryItem] = []
    var searchHistoryList: [Int] = []
    var fetchingMore = false
    var recentNumber = 0
    var page = 0
    let lotteryViewModel = LotteryViewModel()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailLottery" {
            let vc = segue.destination as! SearchLotteryViewController
            vc.lotteryInfo = sender as! LotteryInfo
        }
    }
    
    // [!] 갱신되는 동안 표시할 뷰?, 공 배경 조정
    override func viewDidLoad() {
        super.viewDidLoad()
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "오류", message: "네트워크 연결을 확인해주세요", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                }
            }
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.tintColor = .AlphaB600
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        configureNavi()
        
        recentNumber = getRecentNumber()
        for i in 0..<10 { getLotteryNumber(drwNo: recentNumber - i) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .white
        searchHistoryList = Storage.retrive("lottery_history.json", from: .documents, as: [Int].self) ?? []
    }
    
    func configureNavi() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 65, height: 44))
        label.text = "조회하기"
        label.textColor = .G900
        label.font = UIFont(name: "Pretendard-Bold", size: 18)!
        customView.addSubview(label)
        
        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftButton
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            .foregroundColor: UIColor.G900,
//            .font: UIFont(name: "Pretendard-Bold", size: 18)!
//        ]
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // 글자 간격
//        let attrString = NSMutableAttributedString(string: explainLabel.text!)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 6
//        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
//        explainLabel.attributedText = attrString
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
        
        // 분으로 계산
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
                self.tableView.reloadData()
            case .failure:
                return
            }
        }
    }
    
    @objc func pullToRefresh() {
        if self.monitor.currentPath.status == .satisfied {
            self.lotteryArray = []
            self.page = 0
            recentNumber = getRecentNumber()
            for i in 0..<10 { getLotteryNumber(drwNo: recentNumber - i) }
            tableView.refreshControl?.endRefreshing()
        } else {
            let alert = UIAlertController(title: "오류", message: "네트워크 연결을 확인해주세요", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default) { action in
                self.tableView.refreshControl?.endRefreshing()
            }
            alert.addAction(confirm)
            self.present(alert, animated: true)
        }
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
            cell.winAmount.text = numberFormatter(number: lotteryArray[indexPath.section].lottery.firstWinamnt) + "원"
            cell.detailButtonHandler = {
                if self.monitor.currentPath.status == .satisfied {
                    self.searchHistoryList = self.searchHistoryList.filter { $0 != self.lotteryArray[indexPath.section].lottery.drwNo }
                    self.searchHistoryList.insert(self.lotteryArray[indexPath.section].lottery.drwNo, at: 0)
                    Storage.store(self.searchHistoryList, to: .documents, as: "lottery_history.json")
                    self.performSegue(withIdentifier: "detailLottery", sender: self.lotteryArray[indexPath.section].lottery)
                } else {
                    let alert = UIAlertController(title: "오류", message: "네트워크 연결을 확인해주세요", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                }
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
        else { return 220 }
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

// MARK: 무한 스크롤
extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset_y = tableView.contentOffset.y
        let tableViewContentSize = tableView.contentSize.height
        let pagination_y = tableView.bounds.size.height

        if contentOffset_y > (tableViewContentSize - pagination_y) && contentOffset_y > 0 {
            if !fetchingMore {
                if monitor.currentPath.status == .satisfied {
                    beingFetch()
                } else {
                    let alert = UIAlertController(title: "오류", message: "네트워크 연결을 확인해주세요", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.tableView.reloadData()
    }
    
    // 페이지 갱신
    private func beingFetch() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.page += 1
            let count = self.recentNumber - (self.page * 10)
            if count > 10 {
                for i in 0..<10 {
                    self.getLotteryNumber(drwNo: count - i)
                }
                self.fetchingMore = false
            } else if count <= 10 && count > 0{
                for i in 1...count {
                    self.getLotteryNumber(drwNo: i)
                }
                self.fetchingMore = false
            }
        }
    }
}