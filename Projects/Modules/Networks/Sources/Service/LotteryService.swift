//
//  LotteryService.swift
//  Networks
//
//  Created by 유지호 on 6/13/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core

import Foundation
import RxSwift

public typealias DefaultLotteryService = BaseService<LotteryAPI>

public protocol LotteryService {
    func getLotteryNumber(_ drawNo: Int) -> Single<LotteryEntity>
    func getLotteryNumberList(_ startNo: Int) -> Single<LotteryEntity>
}

extension DefaultLotteryService: LotteryService {
    
    public func getLotteryNumber(_ drawNo: Int) -> Single<LotteryEntity> {
        request(.getLotteryNumber(drawNo))
    }
    
    public func getLotteryNumberList(_ startNo: Int) -> Single<LotteryEntity> {
        request(.getLotteryList(startNo))
    }
    
}
