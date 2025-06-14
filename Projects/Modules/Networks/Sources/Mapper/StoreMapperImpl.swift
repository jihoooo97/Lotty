//
//  StoreMapperImpl.swift
//  Networks
//
//  Created by 유지호 on 6/14/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import Domain

import Foundation
import RxSwift

public final class StoreMapperImpl: StoreMapper {
    
    private let service: StoreService
    
    public init(service: StoreService) {
        self.service = service
    }
    
    
    public func getStoreList(x: Double, y: Double) -> Observable<[StoreModel]> {
        service.getStoreList(x: x, y: y)
            .map { $0.documents.map { $0.toDomain() } }
            .asObservable()
    }
    
    public func searchStore(keyword: String) -> Observable<StoreModel?> {
        service.searchStore(keyword: keyword)
            .map { $0.documents.first?.toDomain() }
            .asObservable()
    }
    
}
