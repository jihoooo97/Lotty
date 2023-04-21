//
//  AroundSearchViewModel.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/07.
//

import Foundation
import RxSwift
import RxRelay

final class AroundSearchViewModel: BaseViewModel {

    private let usecase: HistoryUsecaseProtocol
    
    // MARK: Input
    let inputTapHistory = PublishRelay<History>()
    let inputDeleteHistory = PublishRelay<History>()
    let inputClearHistory = PublishRelay<Void>()
    
    // MARK: Output
    let historyListRelay = BehaviorRelay<[History]>(value: [])
    
    
    init(usecase: HistoryUsecaseProtocol) {
        self.usecase = usecase
        super.init()
     
        inputBind()
    }
    
    
    private func inputBind() {
        inputTapHistory
            .withUnretained(self).map { $0 }
            .bind { vm, history in
                vm.selectHistory(keyword: history.keyword)
                vm.loadHistory()
            }
            .disposed(by: disposeBag)
        
        inputDeleteHistory
            .withUnretained(self).map { $0 }
            .bind { vm, history in
                vm.deleteHistory(keyword: history.keyword)
                vm.loadHistory()
            }
            .disposed(by: disposeBag)
        
        inputClearHistory
            .withUnretained(self).map { $0.0 }
            .bind { vm in
                vm.clearHistory()
                vm.loadHistory()
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: History
    func selectHistory(keyword: String) {
        usecase.select(keyword: keyword, type: .map)
    }
    
    func loadHistory() {
        let historyList = usecase.load(type: .map)
        historyListRelay.accept(historyList)
    }
    
    func deleteHistory(keyword: String) {
        usecase.delete(keyword: keyword, type: .map)
    }
    
    func clearHistory() {
        usecase.clear(type: .map)
    }
    
}
