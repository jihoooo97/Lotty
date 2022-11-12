import Foundation

struct LotteryInfo: Entity {
    let drwNoDate: String
    let drwNo: Int            // 회차
    var firstAccumamnt: Int   // 총 상금
    let firstWinamnt: Int     // 1인당 상금
    let firstPrzwnerCo: Int   // 1등 당첨수
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
    let returnValue: String
    let totSellamnt: Int
    
    static func initLottery() -> LotteryInfo {
        return LotteryInfo(
            drwNoDate: "",
            drwNo: 0,
            firstAccumamnt: 0,
            firstWinamnt: 0,
            firstPrzwnerCo: 0,
            drwtNo1: 0,
            drwtNo2: 0,
            drwtNo3: 0,
            drwtNo4: 0,
            drwtNo5: 0,
            drwtNo6: 0,
            bnusNo: 0,
            returnValue: "",
            totSellamnt: 0
        )
    }
}

struct LotteryItem {
    let lottery: LotteryInfo
    var open = false
}

struct LotteryFail: Codable {
    let returnValue: String
}
