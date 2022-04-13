import Alamofire
import RxSwift

class LotteryViewModel {
    var historyList: [Int] = []
    var lotteryItems: [LotteryItem] = []
    var lotteryRx = BehaviorSubject<[LotteryItem]>(value: [])
    var recentNumber = 0
    var page = 0
    var fetchingMore = false
    
    var numberOfLotteryList: Int {
        return lotteryItems.count
    }
    
    func getNowTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "ko-KR") as TimeZone?
        return formatter.string(from: now)
    }
    
    func getRecentNumber() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let base = 1002
        let now = getNowTime()
        
        guard let startTime = formatter.date(from: "2022-02-12 20:45:00") else { return }
        guard let endTime = formatter.date(from: now) else { return }
        
        // 분으로 계산
        let subTime = Int(endTime.timeIntervalSince(startTime)) / 60
        let count = subTime / 10080
        recentNumber = base + count
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
                    self.lotteryItems.append(LotteryItem(lottery: lottery, open: true))
                } else {
                    self.lotteryItems.append(LotteryItem(lottery: lottery))
                }
                print(self.lotteryItems.count)
                self.lotteryItems.sort(by: { $0.lottery.drwNo > $1.lottery.drwNo })
            case .failure:
                return
            }
        }
    }
    
    func loadHistory() {
        historyList = Storage.retrive("lottery_history.json", from: .documents, as: [Int].self) ?? []
    }
    
    func saveHistory() {
        Storage.store(historyList, to: .documents, as: "lottery_history.json")
    }
    
    func updateHistory(section: Int) {
        historyList = historyList.filter { $0 != lotteryItems[section].lottery.drwNo }
        historyList.insert(lotteryItems[section].lottery.drwNo, at: 0)
    }
}
