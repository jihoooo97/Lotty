//
//  LottyRequestInterceptor.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import Foundation
import Alamofire

final class LottyRequestInterceptor: RequestInterceptor {
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        guard urlRequest.url?.absoluteString.hasPrefix("https://dapi.kakao.com") == true else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue(
            "KakaoAK 7165edf50ee98e1383adf5924f5a76ad",
            forHTTPHeaderField: "Authorization"
        )
        completion(.success(urlRequest))
    }
    
}
