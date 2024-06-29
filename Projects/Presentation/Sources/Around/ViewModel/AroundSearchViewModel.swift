//
//  AroundSearchViewModel.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/07.
//

import Domain
import Foundation
import RxSwift
import RxRelay

public final class AroundSearchViewModel {

    private let useCase: HistoryUseCase
    
    // MARK: Input
    let inputTapHistory = PublishRelay<History>()
    let inputDeleteHistory = PublishRelay<History>()
    let inputClearHistory = PublishRelay<Void>()
    
    // MARK: Output
    let historyListRelay = BehaviorRelay<[History]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    public init(useCase: HistoryUseCase) {
        self.useCase = useCase
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
        useCase.select(keyword: keyword, type: .map)
    }
    
    func loadHistory() {
        let historyList = useCase.load(type: .map)
        historyListRelay.accept(historyList)
    }
    
    func deleteHistory(keyword: String) {
        useCase.delete(keyword: keyword, type: .map)
    }
    
    func clearHistory() {
        useCase.clear(type: .map)
    }
    
}
