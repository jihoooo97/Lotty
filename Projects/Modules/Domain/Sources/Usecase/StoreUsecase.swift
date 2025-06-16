//
//  StoreUsecase.swift
//  Domain
//
//  Created by 유지호 on 6/14/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core

import RxSwift
import RxRelay

public protocol StoreUsecase {
    var storeSearchResult: PublishRelay<StoreModel?> { get }
    var storeList: PublishRelay<[StoreModel]> { get }
    
    func getStoreList(x: Double, y: Double)
    func searchStore(keyword: String)
}

public final class DefaultStoreUsecase: StoreUsecase {
    
    private let mapper: StoreMapper
    private let bag = DisposeBag()
    
    public let storeSearchResult = PublishRelay<StoreModel?>()
    public let storeList = PublishRelay<[StoreModel]>()
    
    public init(mapper: StoreMapper) {
        self.mapper = mapper
    }
    
    
    public func getStoreList(x: Double, y: Double) {
        mapper.getStoreList(x: x, y: y)
            .withUnretained(self)
            .subscribe { owner, storeList in
                owner.storeList.accept(storeList)
            }.disposed(by: bag)
    }
    
    public func searchStore(keyword: String) {
        mapper.searchStore(keyword: keyword)
            .withUnretained(self)
            .subscribe { owner, store in
                owner.storeSearchResult.accept(store)
            }.disposed(by: bag)
    }
    
}
