//
//  APIBase.swift
//  Lotty
//
//  Created by JihoMac on 2022/04/15.
//

import Alamofire

// MARK: - Request
protocol APIRequest: Codable { }

class APIPageableRequest: APIRequest {
    
}

// MARK: - Response
protocol APIResponse: Codable { }

class APIPageableResponse<T: APIResponse>: APIRequest {
    
}

class APIErrorResponse: Codable {
    
}

// MARK: - API Template
class APIBase: NSObject {
    var url = ""
    var method: HTTPMethod = HTTPMethod.get
    var pathValue: [String: String]?
}

extension APIBase {
    func getUrl() -> URL {
        pathValue?.forEach{ [weak self] (item) in
            if let escapedString = item.value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                self?.replaceVariablePath(varKey: item.key, value: escapedString)
            }
        }
        return URL(string: url)!
    }
    
    private func replaceVariablePath(varKey: String, value: String) {
        url = url.replacingOccurrences(of: "{\(varKey)}", with: value)
    }
}
