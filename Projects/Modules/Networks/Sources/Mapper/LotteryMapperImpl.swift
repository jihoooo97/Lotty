//
//  LotteryMapperImpl.swift
//  Networks
//
//  Created by 유지호 on 6/14/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import Domain

import Foundation
import RxSwift

public final class LotteryMapperImpl: LotteryMapper {
    
    private let service: LotteryService
    
    public init(service: LotteryService) {
        self.service = service
    }
    
    
    public func getLotteryNumber(_ drawNo: Int) -> Observable<LotteryModel> {
        service.getLotteryNumber(drawNo)
            .map { $0.toDomain() }
            .asObservable()
    }
    
}
