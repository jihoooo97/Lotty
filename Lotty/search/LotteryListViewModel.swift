import Foundation
import RxSwift
import RxRelay

final class LotteryListViewModel: BaseViewModel {
    
    // MARK: UseCase
    let lotteryUseCase = LotteryUseCase()
    
    // MARK: Input
    
    
    // MARK: Output
    var historyList: [Int] = []
    var lotteryItems: [LotteryItem] = []
    var lotteryListRelay = BehaviorRelay<[LotteryItem]>(value: [])
    
    var recentNumber = 0
    var page = 0
    var fetchingMore = false
    
    
    func getLotteryNumber(drwNo: Int) {
        for i in 0..<10 {
            lotteryUseCase.getLottery(
                drwNo: drwNo - i,
                success: { [weak self] response in
                    guard let lottery = response else { return }
                    guard let items = self?.lotteryItems else { return }
                    if !items.contains(where: { $0.lottery.drwNo == lottery.drwNo } ) {
                        if lottery.drwNo == self?.recentNumber {
                            self?.lotteryItems.append(LotteryItem(lottery: lottery, open: true))
                        } else {
                            self?.lotteryItems.append(LotteryItem(lottery: lottery))
                        }
                        print(self?.lotteryItems.count)
                        self?.lotteryItems.sort(by: { $0.lottery.drwNo > $1.lottery.drwNo })
                        self?.lotteryListRelay.accept(self?.lotteryItems ?? [])
                    }
                },
                failure: { error in
                    print(error)
                }
            )
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
    
}
