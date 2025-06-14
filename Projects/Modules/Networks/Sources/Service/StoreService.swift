//
//  StoreService.swift
//  Networks
//
//  Created by 유지호 on 6/13/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import Domain

import Foundation
import RxSwift

public typealias DefaultStoreService = BaseService<StoreAPI>

public protocol StoreService {
    func getStoreList(x: Double, y: Double) -> Single<StoreEntity>
    func searchStore(keyword: String) -> Single<StoreEntity>
}

extension DefaultStoreService: StoreService {
    
    public func getStoreList(x: Double, y: Double) -> Single<StoreEntity> {
        request(.getStoreList(x: x, y: y))
    }
    
    public func searchStore(keyword: String) -> Single<StoreEntity> {
        request(.searchStore(keyword: keyword))
    }
    
}
