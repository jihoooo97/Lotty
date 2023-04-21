import Foundation
import RxSwift
import RxRelay

final class LotteryListViewModel: BaseViewModel {
    
    // MARK: Usecase
    private let usecase: LotteryUsecaseProtocol
    
    // MARK: Input
    
    // MARK: Output
    var lotteryList: [Lottery] = []
    let isReload = PublishRelay<Void>()
    
    private var currentPage = 1
    private var fetchingMore = false
    
    init(usecase: LotteryUsecaseProtocol) {
        self.usecase = usecase
        super.init()
        
        getLotteryNumber(turn: -1)
    }
    
    
    func getLotteryNumber(turn: Int) {
        let _turn = turn > 0 ? turn : getRecentTurn()
        
        usecase.getLotteryList(turn: _turn, recent: getRecentTurn()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let lotteryList):
                self.lotteryList = lotteryList
                self.currentPage = 1
                self.fetchingMore = true
                self.isReload.accept(())
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getMoreLotteryList() {
        if !fetchingMore { return }
        fetchingMore = false
        
        let currentTurn = getRecentTurn() - (currentPage * 10)
        
        if currentTurn < 1 { return }
        usecase.getMoreLotteryList(turn: currentTurn) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let lotteryList):
                self.lotteryList.append(contentsOf: lotteryList)
                self.currentPage += 1
                self.fetchingMore = true
                self.isReload.accept(())
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func resetLotteryList() {
        getLotteryNumber(turn: -1)
    }
    
    func getRecentTurn() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let base = 1002
        let now = getNowTime()
        
        guard let startTime = formatter.date(from: "2022-02-12 20:45:00"),
              let endTime = formatter.date(from: now) else { return base }
        
        // 분으로 계산
        let subTime = Int(endTime.timeIntervalSince(startTime)) / 60
        let count = subTime / 10080
        return base + count
    }
    
    func getNowTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "ko-KR") as TimeZone?
        return formatter.string(from: now)
    }
        
}
