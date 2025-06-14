//
//  APIType.swift
//  Networks
//
//  Created by 유지호 on 6/13/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Foundation
import Moya

public protocol BaseAPI: TargetType {
    static var apiType: APIType { get set }
}

extension BaseAPI {
    
    public var baseURL: URL {
        var urlString = ""
        
        switch Self.apiType {
        case .lottery:
            urlString = "https://www.dhlottery.co.kr"
        case .store:
            urlString = "https://dapi.kakao.com"
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("baseURL could not be configured")
        }
        
        return url
    }
    
    public var headers: [String : String]? {
        HeaderType.json.value
    }
    
}

public enum APIType {
    case lottery
    case store
}

enum HeaderType {
    case json
    case jsonWithKakaoAK
    
    var value: [String: String] {
        switch self {
        case .json:
            ["Content-Type": "application/json"]
        case .jsonWithKakaoAK:
            ["Content-Type": "application/json",
             "Authorization": "KakaoAK 7165edf50ee98e1383adf5924f5a76ad"]
        }
    }
}
