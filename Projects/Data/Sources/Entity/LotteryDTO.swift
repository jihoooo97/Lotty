//
//  Lottery.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/15.
//

import Domain

public struct LotteryDTO: Decodable {
    public let drawNumberDate: String
    public let turn: Int
    public let drawNo1: Int
    public let drawNo2: Int
    public let drawNo3: Int
    public let drawNo4: Int
    public let drawNo5: Int
    public let drawNo6: Int
    public let bonusNo: Int
    public let winnerCount: Int
    public let winnerPrizeAmount: Int
    public let prizeAmount: Int
    public let totalSellAmount: Int
    public let returnValue: String
    
    enum CodingKeys: String, CodingKey {
        case drawNumberDate = "drwNoDate"           // 추첨일
        case turn = "drwNo"                         // 회차
        case drawNo1 = "drwtNo1"
        case drawNo2 = "drwtNo2"
        case drawNo3 = "drwtNo3"
        case drawNo4 = "drwtNo4"
        case drawNo5 = "drwtNo5"
        case drawNo6 = "drwtNo6"
        case bonusNo = "bnusNo"
        case winnerCount = "firstPrzwnerCo"         // 1등 수
        case winnerPrizeAmount = "firstWinamnt"     // 1등 상금
        case prizeAmount = "firstAccumamnt"         // 총 상금
        case totalSellAmount = "totSellamnt"        // 복권 총 판매금액
        case returnValue
    }
}


public extension LotteryDTO {

    func toDomain() -> Lottery {
        return .init(
            isOpen: false,
            drawNumberDate: drawNumberDate,
            turn: turn,
            drawNo1: drawNo1,
            drawNo2: drawNo2,
            drawNo3: drawNo3,
            drawNo4: drawNo4,
            drawNo5: drawNo5,
            drawNo6: drawNo6,
            bonusNo: bonusNo,
            winnerCount: winnerCount,
            winnerPrizeAmount: winnerPrizeAmount.toDigits(),
            prizeAmount: (
                prizeAmount == 0 ? winnerCount * winnerPrizeAmount : prizeAmount
            ).toDigits(),
            totalSellAmount: totalSellAmount.toDigits()
        )
    }
    
}
