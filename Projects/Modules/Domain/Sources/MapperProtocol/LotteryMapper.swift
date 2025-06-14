//
//  LotteryMapper.swift
//  Domain
//
//  Created by 유지호 on 6/14/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core

import Foundation
import RxSwift

public protocol LotteryMapper {
    func getLotteryNumber(_ drawNo: Int) -> Observable<LotteryModel>
}
