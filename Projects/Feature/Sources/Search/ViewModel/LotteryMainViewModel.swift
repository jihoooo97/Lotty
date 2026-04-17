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
        let tableViewDidRefresh: Observable<Void>
        let tableViewDidScroll: Observable<Void>
    }
    
    public struct Output {
        let lotteryList = BehaviorRelay<[LotteryModel]>(value: [])
        let isLoading = BehaviorRelay<Bool>(value: false)
    }
    
    private let lotteryUsecase: LotteryUsecase
    private var bag = DisposeBag()
    
    private var page = 0
    
    public init(lotteryUsecase: LotteryUsecase) {
        self.lotteryUsecase = lotteryUsecase
    }
    
    deinit {
        bag = .init()
    }
    
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        bindOutput(with: output)
        
        input.tableViewDidRefresh
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.page = 0
                output.isLoading.accept(false)
                output.lotteryList.accept([])
            }.disposed(by: bag)
        
        input.tableViewDidScroll
            .withUnretained(self)
            .filter { _ in !output.isLoading.value }
            .subscribe { owner, _ in
                output.isLoading.accept(true)
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
                output.isLoading.accept(false)
                owner.page += 1
            }.disposed(by: bag)
    }
    
    public func toggleItem(with output: Output, at index: Int) {
        var lotteryList = output.lotteryList.value
        lotteryList[index].isOpen.toggle()
        output.lotteryList.accept(lotteryList)
    }
    
}
