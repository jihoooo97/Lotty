import Alamofire

class DetailViewModel {
    var historyList: [Int] = []
    var lotteryInfo = LotteryInfo(drwNoDate: "", drwNo: 0, firstAccumamnt: 0, firstWinamnt: 0, firstPrzwnerCo: 0, drwtNo1: 0, drwtNo2: 0, drwtNo3: 0, drwtNo4: 0, drwtNo5: 0, drwtNo6: 0, bnusNo: 0, returnValue: "", totSellamnt: 0)
    
    func updateLottery(model: LotteryInfo) {
        lotteryInfo = model
    }
    
    func searchDrwNo(drwNo: String) {
        let parameters: Parameters = [
            "method": "getLottoNumber",
            "drwNo": drwNo
        ]
        AF.request("https://www.dhlottery.co.kr/common.do", method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate(statusCode: 200..<300).responseDecodable(of: LotteryInfo.self) { response in
            switch response.result {
            case .success:
                guard let lottery = response.value else { return }
                self.lotteryInfo = lottery
                if self.lotteryInfo.firstAccumamnt == 0 {
                    self.lotteryInfo.firstAccumamnt = lottery.firstPrzwnerCo * lottery.firstWinamnt
                }
                self.updateHistory(index: -1)
            case .failure:
                return
            }
        }
    }
    
    func clickHistory(index: Int) {
        let parameters: Parameters = [
            "method": "getLottoNumber",
            "drwNo": historyList[index]
        ]
        AF.request("https://www.dhlottery.co.kr/common.do", method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate(statusCode: 200..<300).responseDecodable(of: LotteryInfo.self) { response in
            switch response.result {
            case .success:
                guard let lottery = response.value else { return }
                self.lotteryInfo = lottery
                if self.lotteryInfo.firstAccumamnt == 0 {
                    self.lotteryInfo.firstAccumamnt = lottery.firstPrzwnerCo * lottery.firstWinamnt
                }
                self.updateHistory(index: index)
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
    
    func updateHistory(index: Int) {
        if index >= 0 { // 리스트 클릭해서 검색
            historyList.remove(at: index)
            historyList.insert(lotteryInfo.drwNo, at: 0)
        } else { // 회차 입력해서 검색
            historyList = historyList.filter { $0 != lotteryInfo.drwNo }
            historyList.insert(lotteryInfo.drwNo, at: 0)
        }
    }
    
    func deleteHistory(index: Int) {
        historyList.remove(at: index)
    }
    
    func clearHistory() {
        historyList = []
        Storage.remove("lottery_history.json", from: .documents)
    }
}
