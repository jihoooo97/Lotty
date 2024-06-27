//
//  StoreRepository.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import Foundation
import Domain

public final class StoreRepositoryImpl: StoreRepository {
    
    private let dataStore: StoreDataStore
    
    public init(dataStore: StoreDataStore) {
        self.dataStore = dataStore
    }
    
    public func getStoreList(
        x: Double,
        y: Double,
        completion: @escaping (Result<[Store], Error>) -> Void
    ) {
        dataStore.getStoreList(x: x, y: y) { result in
            switch result {
            case .success(let storeList):
                completion(.success(storeList.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func searchStore(
        keyword: String,
        completion: @escaping (Result<Store?, Error>) -> Void
    ) {
        dataStore.searchStore(keyword: keyword) { result in
            switch result {
            case .success(let store):
                if let store = store.toDomain().first {
                    completion(.success(store))
                } else {
                    completion(.success(nil))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

}
