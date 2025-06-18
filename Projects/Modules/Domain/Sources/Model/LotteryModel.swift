//
//  LotteryModel.swift
//  Domain
//
//  Created by 유지호 on 6/13/25.
//  Copyright © 2025 Lotty. All rights reserved.
//


public struct LotteryModel {
    public var isOpen: Bool
    public let drawnDate: String
    public let drawNo: Int
    public let winNo1, winNo2, winNo3, winNo4, winNo5, winNo6, bonusNo: Int
    public let winnerCount, winnerPrizeAmount, prizeAmount, totalSellAmount: Int
    
    public init(
        isOpen: Bool,
        drawnDate: String,
        drawNo: Int,
        winNo1: Int,
        winNo2: Int,
        winNo3: Int,
        winNo4: Int,
        winNo5: Int,
        winNo6: Int,
        bonusNo: Int,
        winnerCount: Int,
        winnerPrizeAmount: Int,
        prizeAmount: Int,
        totalSellAmount: Int
    ) {
        self.isOpen = isOpen
        self.drawnDate = drawnDate
        self.drawNo = drawNo
        self.winNo1 = winNo1
        self.winNo2 = winNo2
        self.winNo3 = winNo3
        self.winNo4 = winNo4
        self.winNo5 = winNo5
        self.winNo6 = winNo6
        self.bonusNo = bonusNo
        self.winnerCount = winnerCount
        self.winnerPrizeAmount = winnerPrizeAmount
        self.prizeAmount = prizeAmount
        self.totalSellAmount = totalSellAmount
    }
}
