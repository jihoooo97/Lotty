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
    var lotteryInfo: PublishRelay<LotteryModel> { get }
    var lotteryList: PublishRelay<[LotteryModel]> { get }
    
    func getLotteryNumber(_ drawNo: Int)
    func getLotteryNumbers(page: Int)
}

public final class DefaultLotteryUsecase: LotteryUsecase {
    
    private let mapper: LotteryMapper
    private let bag = DisposeBag()
    
    public let lotteryInfo = PublishRelay<LotteryModel>()
    public let lotteryList = PublishRelay<[LotteryModel]>()
    
    private var recentDrawNo = 1176
    
    public init(mapper: LotteryMapper) {
        self.mapper = mapper
        checkRecentDrawNo()
    }
    
    
    public func getLotteryNumber(_ drawNo: Int) {
        mapper.getLotteryNumber(drawNo)
            .withUnretained(self)
            .subscribe { owner, lottery in
                owner.lotteryInfo.accept(lottery)
            }.disposed(by: bag)
    }
    
    public func getLotteryNumbers(page: Int) {
        Observable.from((page * 10)..<(page + 1) * 10)
            .filter { self.recentDrawNo - $0 >= 1 }
            .concatMap { self.mapper.getLotteryNumber(self.recentDrawNo - $0) }
            .map { lottery in
                if lottery.drawNo == self.recentDrawNo {
                    var lottery = lottery
                    lottery.isOpen = true
                    return lottery
                } else {
                    return lottery
                }
            }
            .toArray()
            .subscribe(onSuccess: { [weak self] lotteryList in
                self?.lotteryList.accept(lotteryList)
            }).disposed(by: bag)
    }
    
    private func checkRecentDrawNo() {
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Seoul")!
        
        var baseComponents = DateComponents()
        baseComponents.year = 2002
        baseComponents.month = 12
        baseComponents.day = 7
        baseComponents.hour = 20
        baseComponents.minute = 45
        baseComponents.timeZone = timeZone
        
        guard let baseDate = calendar.date(from: baseComponents) else { return }
        
        let timeInterval = Date.now.timeIntervalSince(baseDate)
        
        // 1주일 = 60 * 60 * 24 * 7 = 604800초
        let weekSeconds: TimeInterval = 604800
        let fullWeeksPassed = Int(timeInterval / weekSeconds)
        
        // 이번 주 토요일 20:45를 계산
//        let nextSaturday = calendar.nextDate(
//            after: Date.now,
//            matching: DateComponents(hour: 20, minute: 45, weekday: 7),
//            matchingPolicy: .nextTimePreservingSmallerComponents,
//            direction: .backward
//        )
        
        recentDrawNo = 1 + fullWeeksPassed
    }
    
}
