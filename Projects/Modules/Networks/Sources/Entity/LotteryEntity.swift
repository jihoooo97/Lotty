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
    public let resultCode: Int?
    public let resultMessage: String?
    public let data: DataList
    
    func toDomain() -> [LotteryModel] {
        return data.list.map { $0.toDomain() }
    }
    
    public struct DataList: Decodable {
        let list: [LotteryDTO]
    }
    
    public struct LotteryDTO: Decodable {
        public let drawnDate: String
        public let drawNo: Int
        public let winNo1, winNo2, winNo3, winNo4, winNo5, winNo6, bonusNo: Int
        public let winnerCount: Int
        public let winnerPrizeAmount, prizeAmount: Int
        public let totalSellAmount: Int
        
        enum CodingKeys: String, CodingKey {
            case drawnDate = "ltRflYmd" // 추첨일
            case drawNo = "ltEpsd" // 회차
            case winNo1 = "tm1WnNo"
            case winNo2 = "tm2WnNo"
            case winNo3 = "tm3WnNo"
            case winNo4 = "tm4WnNo"
            case winNo5 = "tm5WnNo"
            case winNo6 = "tm6WnNo"
            case bonusNo = "bnsWnNo"
            case winnerCount = "rnk1WnNope" // 1등 수
            case winnerPrizeAmount = "rnk1WnAmt" // 1등 상금
            case prizeAmount = "rnk1SumWnAmt" // 총 상금
            case totalSellAmount = "wholEpsdSumNtslAmt" // 복권 총 판매금액
        }
        
        func toDomain() -> LotteryModel {
            return .init(
                isOpen: false,
                drawnDate: "\(drawnDate.prefix(4))-\(drawnDate.dropFirst(4).prefix(2))-\(drawnDate.suffix(2))",
                drawNo: drawNo,
                winNumbers: [winNo1, winNo2, winNo3, winNo4, winNo5, winNo6],
                bonusNo: bonusNo,
                winnerCount: winnerCount,
                winnerPrizeAmount: winnerPrizeAmount,
                prizeAmount: prizeAmount,
                totalSellAmount: totalSellAmount
            )
        }
    }
}
