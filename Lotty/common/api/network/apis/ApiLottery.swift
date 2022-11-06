import Foundation
import Alamofire

class ApiLottery: ApiBase {
    
    override init() {
        super.init()
        
        url = "https://www.dhlottery.co.kr/common.do"
        method = .get
        header = .default
    }
    
}


class LotteryRequest: ApiRequest {
    var drwNo: Int?
    var method: String? = "getLottoNumber"
}

class LotteryResponse: ApiResponse {
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
}
