//
//  LotteryAPI.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/15.
//

import Alamofire

enum LotteryAPI {
    case getLottery(turn: Int)
}

extension LotteryAPI: TargetType {
    
    var baseURL: String {
        return "https://www.dhlottery.co.kr"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getLottery:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getLottery:
            return "/common.do"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case let .getLottery(turn):
            let parameters = ["drwNo" : "\(turn)",
                              "method" : "getLottoNumber"]
            return .query(parameters)
        }
    }
    
}
