struct LotteryInfo: Codable {
    let drwNoDate: String
    let drwNo: Int            // 회차
    let firstWinamnt: Int     // 상금
    let firstPrzwnerCo: Int   // 1등 당첨수
    let drwtNo1: Int
    let drwtNo2: Int
    let drwtNo3: Int
    let drwtNo4: Int
    let drwtNo5: Int
    let drwtNo6: Int
    let bnusNo: Int
    
//    let returnValue: String
//    let firstAccumamnt: Int
//    let totSellamnt: Int
}

struct LotteryItem {
    let lottery: LotteryInfo
    var open = false
}
