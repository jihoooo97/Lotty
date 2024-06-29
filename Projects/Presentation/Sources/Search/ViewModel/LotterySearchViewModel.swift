import Domain
import Common
import Foundation
import RxSwift
import RxRelay

public final class LotterySearchViewModel {
    
    private let lotteryUseCase: LotteryUseCase
    private let historyUseCase: HistoryUseCase
    
    // MARK: Input
    let inputTapHistory = PublishRelay<History>()
    let inputDeleteHistory = PublishRelay<History>()
    let inputClearHistory = PublishRelay<Void>()
    
    // MARK: Output
    let lotteryInfoRelay = PublishRelay<Lottery>()
    let historyListRelay = BehaviorRelay<[History]>(value: [])
    let searchResultErrorRelay = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    
    public init(
        lotteryUseCase: LotteryUseCase,
        historyUseCase: HistoryUseCase
    ) {
        self.lotteryUseCase = lotteryUseCase
        self.historyUseCase = historyUseCase
        
        loadHistory()
        inputBind()
    }

    
    private func inputBind() {
        inputTapHistory
            .bind { [weak self] history in
                guard let turn = Int(history.keyword) else { return }
                self?.searchLottery(turn: turn)
            }
            .disposed(by: disposeBag)
        
        inputDeleteHistory
            .bind { [weak self] history in
                let turn = history.keyword
                self?.deleteHistory(turn: turn)
                self?.loadHistory()
            }
            .disposed(by: disposeBag)
        
        inputClearHistory
            .bind { [weak self] event in
                self?.clearHistory()
                self?.loadHistory()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: Lottery
    func searchLottery(turn: Int) {
        lotteryUseCase.getLottery(turn: turn) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let lottery):
                self.lotteryInfoRelay.accept(lottery)
                self.selectHistory(turn: String(turn))
                self.loadHistory()
            case .failure(let error):
                print(error.localizedDescription)
                self.searchResultErrorRelay.accept(())
            }
        }
    }
    
    // MARK: History
    func selectHistory(turn: String) {
        historyUseCase.select(keyword: turn, type: .lottery)
    }
    
    func loadHistory() {
        let historyList = historyUseCase.load(type: .lottery)
        historyListRelay.accept(historyList)
    }
    
    func deleteHistory(turn: String) {
        historyUseCase.delete(keyword: turn, type: .lottery)
    }
    
    func clearHistory() {
        historyUseCase.clear(type: .lottery)
    }
    
}
