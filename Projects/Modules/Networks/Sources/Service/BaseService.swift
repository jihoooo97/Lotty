//
//  BaseService.swift
//  Networks
//
//  Created by 유지호 on 6/13/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public class BaseService<Target: TargetType> {
    
    public typealias API = Target
    
    lazy var provider = defaultProvider
    
    // MARK: Provider
    private lazy var defaultProvider: MoyaProvider<API> = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let session = Session(configuration: configuration, delegate: .init())
        let provider = MoyaProvider<API>(
//            endpointClosure: endpointClosure,
            session: session,
            plugins: [LoggingPlugin()]
        )
        
        return provider
    }()
    
    public init() { }
    
}


public extension BaseService {
    
    func request<T: Decodable>(_ target: API) -> Single<T> {
        return Single.create { [weak self] single in
            self?.provider.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let body = try JSONDecoder().decode(T.self, from: response.data)
                        single(.success(body))
                    } catch {
                        // 디코딩 실패
                        single(.failure(error))
                    }
                    
                // 통신 실패
                case .failure(let error):
                    single(.failure(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
}
