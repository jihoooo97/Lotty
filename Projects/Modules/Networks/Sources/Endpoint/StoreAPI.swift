//
//  StoreAPI.swift
//  Networks
//
//  Created by 유지호 on 6/13/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core

import Foundation
import Moya

public enum StoreAPI: BaseAPI {
    case getStoreList(x: Double, y: Double)
    case searchStore(keyword: String)
}

public extension StoreAPI {
    
    static var apiType: APIType = .store
    
    var path: String { "/v2/local/search/keyword.json" }
    
    var method: Moya.Method { .get }
    
    var task: Moya.Task {
        switch self {
        case let .getStoreList(x, y):
                .requestParameters(
                    parameters: ["x": x, "y": y,
                                 "query": "복권 판매점",
                                 "size": 15,
                                 "sort": "distance"],
                    encoding: URLEncoding.queryString
                )
            
        case let .searchStore(keyword):
                .requestParameters(
                    parameters: ["query": keyword + " 복권 판매점",
                                 "size": 1],
                    encoding: URLEncoding.queryString
                )
        }
    }
    
    var headers: [String : String]? {
        HeaderType.jsonWithKakaoAK.value
    }
    
}
