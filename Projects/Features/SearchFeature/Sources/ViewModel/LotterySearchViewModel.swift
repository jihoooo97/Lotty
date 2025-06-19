//
//  LotterySearchViewModel.swift
//  SearchFeature
//
//  Created by 유지호 on 6/19/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import BaseFeature
import Core
import Domain

import Foundation
import RxSwift
import RxRelay

public final class LotterySearchViewModel: ViewModelable {
    
    public struct Input {
        let viewDidLoad: Observable<Void>
        let searchFieldDidChange: Observable<String>
        let searchHistoryDidTap: Observable<String>
        let searchHistoryDeleteButtonDidTap: Observable<String>
        let clearButtonDidTap: Observable<Void>
    }
    
    public struct Output {
        let searchResult = PublishRelay<LotteryModel?>()
        let searchHistory = BehaviorRelay<[HistoryModel]>(value: [])
    }
    
    private let lotteryUsecase: LotteryUsecase
    private let historyUsecase: SearchHistoryUsecase
    
    private let bag = DisposeBag()
    
    public init(lotteryUsecase: LotteryUsecase, historyUsecase: SearchHistoryUsecase) {
        self.lotteryUsecase = lotteryUsecase
        self.historyUsecase = historyUsecase
    }
    
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        bindOutput(with: output)
        
        input.viewDidLoad
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.historyUsecase.load()
            }.disposed(by: bag)
        
        input.searchFieldDidChange
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, text in
                guard let drawNo = Int(text) else { return }
                owner.lotteryUsecase.getLotteryNumber(drawNo)
            }.disposed(by: bag)
        
        input.searchHistoryDidTap
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { owner, text in
                guard let drawNo = Int(text) else { return }
                owner.lotteryUsecase.getLotteryNumber(drawNo)
            }.disposed(by: bag)
        
        input.searchHistoryDeleteButtonDidTap
            .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, text in
                owner.historyUsecase.remove(keyword: text)
            }.disposed(by: bag)
        
        input.clearButtonDidTap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.historyUsecase.clear()
            }.disposed(by: bag)
        
        return output
    }
    
    private func bindOutput(with output: Output) {
        lotteryUsecase.lotteryInfo
            .withUnretained(self)
            .subscribe { owner, lottery in
                output.searchResult.accept(lottery)
                owner.historyUsecase.add(keyword: "\(lottery.drawNo)")
            }.disposed(by: bag)
        
        historyUsecase.historyList
            .withUnretained(self)
            .subscribe { owner, historyList in
                output.searchHistory.accept(historyList)
            }.disposed(by: bag)
    }
    
}
