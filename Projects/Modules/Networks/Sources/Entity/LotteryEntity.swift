//
//  LotteryEntity.swift
//  Domain
//
//  Created by 유지호 on 6/13/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Domain

import Foundation

public struct LotteryEntity: Decodable {
    public let drawnDate: String
    public let drawNo: Int
    public let winNo1, winNo2, winNo3, winNo4, winNo5, winNo6, bonusNo: Int
    public let winnerCount: Int
    public let winnerPrizeAmount, prizeAmount: Int
    public let totalSellAmount: Int
    public let returnValue: String
    
    enum CodingKeys: String, CodingKey {
        case drawnDate = "drwNoDate"                // 추첨일
        case drawNo = "drwNo"                       // 회차
        case winNo1 = "drwtNo1"
        case winNo2 = "drwtNo2"
        case winNo3 = "drwtNo3"
        case winNo4 = "drwtNo4"
        case winNo5 = "drwtNo5"
        case winNo6 = "drwtNo6"
        case bonusNo = "bnusNo"
        case winnerCount = "firstPrzwnerCo"         // 1등 수
        case winnerPrizeAmount = "firstWinamnt"     // 1등 상금
        case prizeAmount = "firstAccumamnt"         // 총 상금
        case totalSellAmount = "totSellamnt"        // 복권 총 판매금액
        case returnValue
    }
    
    func toDomain() -> LotteryModel {
        return .init(
            isOpen: false,
            drawnDate: drawnDate,
            drawNo: drawNo,
            winNo1: winNo1,
            winNo2: winNo2,
            winNo3: winNo3,
            winNo4: winNo4,
            winNo5: winNo5,
            winNo6: winNo6,
            bonusNo: bonusNo,
            winnerCount: winnerCount,
            winnerPrizeAmount: winnerPrizeAmount,
            prizeAmount: prizeAmount,
            totalSellAmount: totalSellAmount
        )
    }
}
