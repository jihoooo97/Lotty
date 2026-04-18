//
//  LotteryAPI.swift
//  Networks
//
//  Created by 유지호 on 6/13/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Foundation
import Moya

public enum LotteryAPI: BaseAPI {
    case getLotteryNumber(_ drawNo: Int)
    case getLotteryList(_ startNo: Int)
}

public extension LotteryAPI {
    
    static var apiType: APIType = .lottery
    
    var path: String { "/lt645/selectPstLt645Info.do" }
    
    var method: Moya.Method { .get }
    
    var task: Moya.Task {
        switch self {
        case .getLotteryNumber(let drawNo):
                .requestParameters(
                    parameters: ["srchLtEpsd": "\(drawNo)"],
                    encoding: URLEncoding.queryString
                )
        case .getLotteryList(let startNo):
                .requestParameters(
                    parameters: ["srchStrLtEpsd": "\(startNo - 9)",
                                 "srchEndLtEpsd": "\(startNo)"],
                    encoding: URLEncoding.queryString
                )
        }
    }
    
    var headers: [String : String]? {
        return HeaderType.jsonWithLottery.value
    }
    
}
