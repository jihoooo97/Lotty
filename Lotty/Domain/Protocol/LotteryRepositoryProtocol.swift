//
//  LotteryRepositoryProtocol.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/16.
//

import Foundation

protocol LotteryRepositoryProtocol {
    func getLottery(turn: Int, completion: @escaping(Result<Lottery, Error>) -> Void)
}
