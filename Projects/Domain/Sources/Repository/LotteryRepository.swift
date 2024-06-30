//
//  LotteryRepository.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/16.
//

import Foundation

public protocol LotteryRepository {
    func getLottery(turn: Int, completion: @escaping(Result<Lottery, Error>) -> Void)
}
