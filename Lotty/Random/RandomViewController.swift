import UIKit
import Alamofire

class RandomViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var lotteryArray: [LotteryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.title = " 조회하기"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        
        for i in 0..<10 {
            getLotteryNumber(drwNo: 1002 - i)
        }
    }
    
    func getNowTime() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "ko-KR") as TimeZone?
        return dateFormatter.string(from: now)
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
                if self.lotteryArray.count == 0 {
                    self.lotteryArray.append(LotteryItem(lottery: lottery, open: true))
                } else {
                    self.lotteryArray.append(LotteryItem(lottery: lottery))
                    self.lotteryArray.sort(by: { $0.lottery.drwNo > $1.lottery.drwNo })
                }
                self.tableView.reloadData()
            case .failure:
                return
            }
        }
    }
}

extension RandomViewController: UITableViewDataSource {
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
            cell.drwNo.text = "\(lotteryArray[indexPath.section].lottery.drwNo)회"
            cell.date.text = lotteryArray[indexPath.section].lottery.drwNoDate
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "numberCell", for: indexPath) as? NumberCell else { return UITableViewCell() }
            cell.no1.text = "\(lotteryArray[indexPath.section].lottery.drwtNo1)"
            cell.no2.text = "\(lotteryArray[indexPath.section].lottery.drwtNo2)"
            cell.no3.text = "\(lotteryArray[indexPath.section].lottery.drwtNo3)"
            cell.no4.text = "\(lotteryArray[indexPath.section].lottery.drwtNo4)"
            cell.no5.text = "\(lotteryArray[indexPath.section].lottery.drwtNo5)"
            cell.no6.text = "\(lotteryArray[indexPath.section].lottery.drwtNo6)"
            cell.bonusNo.text = "\(lotteryArray[indexPath.section].lottery.bnusNo)"
            cell.winAmount.text = "1등 상금: \(lotteryArray[indexPath.section].lottery.firstWinamnt)"
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
        label.layer.cornerRadius = 15
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

extension RandomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return 60 }
        else { return 200 }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NumberCloseCell else { return }
        guard let index = tableView.indexPath(for: cell) else { return }
        
        if index.row == indexPath.row && index.row == 0 {
            if lotteryArray[indexPath.section].open == true {
                lotteryArray[indexPath.section].open = false
                cell.status.image = UIImage(named: "1814087_arrow_top_up_icon")
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            } else {
                lotteryArray[indexPath.section].open = true
                cell.status.image = UIImage(named: "1814082_arrow_bottom_down_icon")
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            }
        }
    }
    
}
