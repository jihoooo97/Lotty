//
//  LotteryModel.swift
//  Domain
//
//  Created by 유지호 on 6/13/25.
//  Copyright © 2025 Lotty. All rights reserved.
//


public struct LotteryModel: Equatable {
    public var isOpen: Bool
    public let drawnDate: String
    public let drawNo: Int
    public let winNumbers: [Int]
    public let bonusNo: Int
    public let winnerCount, winnerPrizeAmount, prizeAmount, totalSellAmount: Int
    
    public init(
        isOpen: Bool,
        drawnDate: String,
        drawNo: Int,
        winNumbers: [Int],
        bonusNo: Int,
        winnerCount: Int,
        winnerPrizeAmount: Int,
        prizeAmount: Int,
        totalSellAmount: Int
    ) {
        self.isOpen = isOpen
        self.drawnDate = drawnDate
        self.drawNo = drawNo
        self.winNumbers = winNumbers
        self.bonusNo = bonusNo
        self.winnerCount = winnerCount
        self.winnerPrizeAmount = winnerPrizeAmount
        self.prizeAmount = prizeAmount
        self.totalSellAmount = totalSellAmount
    }
}
