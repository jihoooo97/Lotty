//
//  StoreAPI.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import Alamofire

enum StoreAPI {
    case getStoreList(x: Double, y: Double)
    case searchStore(keyword: String)
}

extension StoreAPI: TargetType {
    
    var baseURL: String {
        return "https://dapi.kakao.com"
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getStoreList, .searchStore:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getStoreList, .searchStore:
            return "/v2/local/search/keyword.json"
        }
    }
    
    var parameters: RequestParams {
        switch self {
        case let .getStoreList(x, y):
            return .query([
                "x": x,
                "y": y,
                "query": "복권 판매점",
                "size": 15
            ])
            
        case let .searchStore(keyword):
            return .query([
                "query": keyword + " 복권 판매점",
                "size": 1
            ])
        }
    }
    
}
