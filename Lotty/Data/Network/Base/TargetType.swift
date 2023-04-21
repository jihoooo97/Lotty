//
//  TargetType.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/15.
//

import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams { get }
}

extension TargetType {

    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        urlRequest.setValue(
            ContentType.json.rawValue,
            forHTTPHeaderField: HTTPHeaderField.contentType.rawValue
        )
        
        switch parameters {
        case .query(let request):
            let params = request ?? [:]
            let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(
                string: url.appendingPathComponent(path).absoluteString
            )
            components?.queryItems = queryParams
            urlRequest.url = components?.url
            
        case .body(let request):
            let params = request ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        }
        
        return urlRequest
    }
    
}


enum RequestParams {
    case query(_ parameter: Parameters?)
    case body(_ parameter: Parameters?)
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
}

enum ContentType: String {
    case json = "Application/json"
}
