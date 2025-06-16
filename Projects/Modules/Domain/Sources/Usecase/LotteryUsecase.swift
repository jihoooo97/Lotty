//
//  LotteryUsecase.swift
//  Domain
//
//  Created by 유지호 on 6/14/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core

import Foundation
import RxSwift
import RxRelay

public protocol LotteryUsecase {
    var lotteryInto: PublishRelay<LotteryModel> { get }
    var lotteryList: PublishRelay<[LotteryModel]> { get }
    
    func getLotteryNumber(_ drawNo: Int)
    func getLotteryNumbers(_ drawNo: Int, page: Int)
}

public final class DefautLotteryUsecase: LotteryUsecase {
    
    private let mapper: LotteryMapper
    private let bag = DisposeBag()
    
    public let lotteryInto = PublishRelay<LotteryModel>()
    public let lotteryList = PublishRelay<[LotteryModel]>()
    
    private var recentDrawNo = 1176
    
    public init(mapper: LotteryMapper) {
        self.mapper = mapper
        checkRecentTurn()
    }
    
    
    public func getLotteryNumber(_ drawNo: Int) {
        mapper.getLotteryNumber(drawNo)
            .withUnretained(self)
            .subscribe { owner, lottery in
                owner.lotteryInto.accept(lottery)
            }.disposed(by: bag)
    }
    
    public func getLotteryNumbers(_ drawNo: Int, page: Int) {
        Observable.from((page * 10)..<(page + 1) * 10)
            .filter { self.recentDrawNo - $0 >= 1 }
            .concatMap { self.mapper.getLotteryNumber($0) }
            .toArray()
            .subscribe(onSuccess: { [weak self] lotteryList in
                self?.lotteryList.accept(lotteryList)
            }).disposed(by: bag)
        
//        var lotteryList: [LotteryModel] = []
//        
//        for index in (page * 10)..<(page + 1) * 10 {
//            if recentDrawNo - index < 1 { return }
//            
//            mapper.getLotteryNumber(recentDrawNo - index)
//                .withUnretained(self)
//                .subscribe { owner, lottery in
//                    var lottery = lottery
//                    lottery.isOpen = lottery.drawNo == owner.recentDrawNo
//                    lotteryList.append(lottery)
//                }.disposed(by: bag)
//        }
//        
//        self.lotteryList.accept(lotteryList)
    }
    
    private func checkRecentTurn() {
        guard let baseDate = Date.fullDate(from: "2025-06-14 20:45:00"),
              let targetDate = Date.fullDate(from: Date.now.fullDateString())
        else { return }
        
        let dateInterval = Int(targetDate.timeIntervalSince(baseDate) / (60 * 60 * 24))
        recentDrawNo += dateInterval
    }
    
}
