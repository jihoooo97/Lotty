//
//  StoreSearchViewModel.swift
//  MapFeature
//
//  Created by 유지호 on 6/14/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import Domain

import Foundation
import RxSwift
import RxRelay

public final class StoreSearchViewModel: ViewModelable {

    private let storeUsecase: StoreUsecase
    private let historyUsecase: SearchHistoryUsecase
    private var bag = DisposeBag()
    
    public var onTapSearchButton: (() -> Void)?
    
    public struct Input {
        let viewDidLoad: Observable<Void>
        let searchTextfieldDidEdit: Observable<String>
        let searchButtonDidTap: Observable<Void>
        let searchHistoryDidTap: Observable<String>
        let searchHistoryDeleteButtonDidTap: Observable<String>
        let clearButtonDidTap: Observable<Void>
    }
    
    public struct Output {
        let searchHistory = BehaviorRelay<[HistoryModel]>(value: [])
    }

    public init(storeUsecase: StoreUsecase, historyUsecase: SearchHistoryUsecase) {
        self.storeUsecase = storeUsecase
        self.historyUsecase = historyUsecase
    }
    
    deinit {
        bag = DisposeBag()
    }
    
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        bindOutput(with: output)
        
        input.viewDidLoad
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.historyUsecase.load()
            }.disposed(by: bag)
        
        input.searchButtonDidTap
            .withLatestFrom(input.searchTextfieldDidEdit)
            .withUnretained(self)
            .subscribe { owner, keyword in
                owner.storeUsecase.searchStore(keyword: keyword)
                owner.historyUsecase.add(keyword: keyword)
            }.disposed(by: bag)
        
        input.searchHistoryDidTap
            .withUnretained(self)
            .subscribe { owner, keyword in
                owner.storeUsecase.searchStore(keyword: keyword)
                owner.historyUsecase.add(keyword: keyword)
            }.disposed(by: bag)
        
        input.searchHistoryDeleteButtonDidTap
            .withUnretained(self)
            .subscribe { owner, keyword in
                owner.historyUsecase.remove(keyword: keyword)
            }.disposed(by: bag)
        
        input.clearButtonDidTap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.historyUsecase.clear()
            }.disposed(by: bag)
        
        return output
    }
    
    private func bindOutput(with output: Output) {
        storeUsecase.storeSearchResult
            .withUnretained(self)
            .bind { owner, result in
                guard let _ = result else {
                    print("No Store")
                    return
                }
                
                owner.onTapSearchButton?()
            }.disposed(by: bag)
        
        historyUsecase.historyList
            .withUnretained(self)
            .bind { owner, histories in
                output.searchHistory.accept(histories)
            }.disposed(by: bag)
    }
    
}
