import Foundation

public struct Lottery: Codable {
    public var isOpen: Bool
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
    public let winnerPrizeAmount: String
    public let prizeAmount: String
    public let totalSellAmount: String
    
    public init(
        isOpen: Bool,
        drawNumberDate: String,
        turn: Int,
        drawNo1: Int,
        drawNo2: Int,
        drawNo3: Int, 
        drawNo4: Int,
        drawNo5: Int,
        drawNo6: Int,
        bonusNo: Int,
        winnerCount: Int,
        winnerPrizeAmount: String,
        prizeAmount: String,
        totalSellAmount: String
    ) {
        self.isOpen = isOpen
        self.drawNumberDate = drawNumberDate
        self.turn = turn
        self.drawNo1 = drawNo1
        self.drawNo2 = drawNo2
        self.drawNo3 = drawNo3
        self.drawNo4 = drawNo4
        self.drawNo5 = drawNo5
        self.drawNo6 = drawNo6
        self.bonusNo = bonusNo
        self.winnerCount = winnerCount
        self.winnerPrizeAmount = winnerPrizeAmount
        self.prizeAmount = prizeAmount
        self.totalSellAmount = totalSellAmount
    }
}
