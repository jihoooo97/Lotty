//
//  LotteryMainViewModel.swift
//  SearchFeature
//
//  Created by 유지호 on 6/17/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import BaseFeature
import Core
import Domain

import Foundation
import RxSwift
import RxRelay

public final class LotteryMainViewModel: ViewModelable {
    
    public struct Input {
        let tableViewDidScroll: Observable<Void>
    }
    
    public struct Output {
        let lotteryList = BehaviorRelay<[LotteryModel]>(value: [])
    }
    
    private let lotteryUsecase: LotteryUsecase
    private var bag = DisposeBag()
    
    var page = 0
    var isLoading = false
    
    public init(lotteryUsecase: LotteryUsecase) {
        self.lotteryUsecase = lotteryUsecase
    }
    
    deinit {
        bag = .init()
    }
    
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        bindOutput(with: output)
        
        input.tableViewDidScroll
            .withUnretained(self)
            .map { $0.0 }
            .filter { !$0.isLoading }
            .subscribe { owner in
                owner.isLoading = true
                owner.lotteryUsecase.getLotteryNumbers(page: owner.page)
            }.disposed(by: bag)
        
        return output
    }
    
    private func bindOutput(with output: Output) {
        lotteryUsecase.lotteryList
            .withUnretained(self)
            .subscribe { owner, lotteryList in
                let currentList = output.lotteryList.value
                output.lotteryList.accept(currentList + lotteryList)
                
                owner.page += 1
                owner.isLoading = false
            }.disposed(by: bag)
    }
    
    public func toggleItem(with output: Output, at index: Int) {
        var lotteryList = output.lotteryList.value
        lotteryList[index].isOpen.toggle()
        output.lotteryList.accept(lotteryList)
    }
    
}
