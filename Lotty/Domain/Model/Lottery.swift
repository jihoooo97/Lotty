import Foundation

struct Lottery: Codable {
    var isOpen: Bool
    let drawNumberDate: String
    let turn: Int
    let drawNo1: Int
    let drawNo2: Int
    let drawNo3: Int
    let drawNo4: Int
    let drawNo5: Int
    let drawNo6: Int
    let bonusNo: Int
    let winnerCount: Int
    let winnerPrizeAmount: String
    let prizeAmount: String
    let totalSellAmount: String
}
