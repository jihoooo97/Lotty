import Foundation
import RxSwift
import RxRelay

final class LotterySearchViewModel: BaseViewModel {
    
    let lotteryUseCase = LotteryUseCase()
    
    private var _historyList: [Int] = []
    var historyListRelay = BehaviorRelay<[Int]>(value: [])
    
    private var _lotteryInfo = LotteryInfo.initLottery()
    var lotteryInfoRelay = BehaviorRelay<LotteryInfo?>(value: nil)
    
    
    override init() {
        super.init()
        
        loadHistory()
    }

    
    // MARK: Lottery
    func updateLottery(lottery: LotteryInfo) {
        _lotteryInfo = lottery
        lotteryInfoRelay.accept(_lotteryInfo)
    }
    
    func searchDrwNo(drwNo: Int) {
        lotteryUseCase.getLottery(
            drwNo: drwNo,
            success: { [weak self] response in
                guard var lottery = response else { return }
                if lottery.firstAccumamnt == 0 {
                    lottery.firstAccumamnt = lottery.firstPrzwnerCo * lottery.firstWinamnt
                }
                self?._lotteryInfo = lottery
                self?.lotteryInfoRelay.accept(self?._lotteryInfo)
                self?.updateHistory(index: -1)
                self?.saveHistory()
            },
            failure: { [weak self] error in
                self?.lotteryInfoRelay.accept(nil)
                if let detail = error.detail {
                    if detail.contains("offline") {
                        AlertManager.shared.showNetworkErrorAlert()
                    }
                }
            }
        )
    }
    
    // MARK: History
    func loadHistory() {
        _historyList = Storage.retrive("lottery_history.json", from: .documents, as: [Int].self) ?? []
        historyListRelay.accept(_historyList)
    }
    
    func saveHistory() {
        Storage.store(_historyList, to: .documents, as: "lottery_history.json")
    }
    
    func updateHistory(index: Int) {
        if index > 0 { // 리스트 클릭해서 검색
            _historyList.remove(at: index)
            _historyList.insert(_lotteryInfo.drwNo, at: 0)
        } else { // 회차 입력해서 검색
            _historyList = _historyList.filter { $0 != _lotteryInfo.drwNo }
            _historyList.insert(_lotteryInfo.drwNo, at: 0)
        }
        historyListRelay.accept(_historyList)
    }
    
    func deleteHistory(index: Int) {
        _historyList.remove(at: index)
        historyListRelay.accept(_historyList)
    }
    
    func clearHistory() {
        _historyList = []
        historyListRelay.accept(_historyList)
        Storage.remove("lottery_history.json", from: .documents)
    }
    
    func clickHistory(index: Int) {
        if index < 0 { return }
        lotteryUseCase.getLottery(
            drwNo: _historyList[index],
            success: { [weak self] response in
                guard var lottery = response else { return }
                if lottery.firstAccumamnt == 0 {
                    lottery.firstAccumamnt = lottery.firstPrzwnerCo * lottery.firstWinamnt
                }
                self?._lotteryInfo = lottery
                self?.lotteryInfoRelay.accept(self?._lotteryInfo)
                self?.updateHistory(index: index)
                self?.saveHistory()
            },
            failure: { error in
                if let detail = error.detail {
                    if detail.contains("offline") {
                        AlertManager.shared.showNetworkErrorAlert()
                    }
                }
            }
        )
    }
    
}
