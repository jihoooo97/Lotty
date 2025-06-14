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
}

public extension LotteryAPI {
    
    static var apiType: APIType = .lottery
    
    var path: String { "/common.do" }
    
    var method: Moya.Method { .get }
    
    var task: Moya.Task {
        switch self {
        case .getLotteryNumber(let drawNo):
                .requestParameters(
                    parameters: ["drwNo" : "\(drawNo)",
                                 "method" : "getLottoNumber"],
                    encoding: URLEncoding.queryString
                )
        }
    }
    
}
