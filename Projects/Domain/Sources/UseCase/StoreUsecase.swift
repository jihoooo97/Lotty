//
//  StoreUsecase.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import Foundation

public protocol StoreUsecaseProtocol {
    func getStoreList(x: Double, y: Double, completion: @escaping(Result<[Store], Error>) -> Void)
    func searchStore(keyword: String, completion: @escaping(Result<Store?, Error>) -> Void)
}

public final class StoreUsecase: StoreUsecaseProtocol {

    private let repository: StoreRepository
    
    public init(repository: StoreRepository) {
        self.repository = repository
    }
    
    
    public func getStoreList(
        x: Double,
        y: Double,
        completion: @escaping (Result<[Store], Error>) -> Void
    ) {
        repository.getStoreList(x: x, y: y) { result in
            switch result {
            case .success(let storeList):
                completion(.success(storeList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func searchStore(
        keyword: String,
        completion: @escaping (Result<Store?, Error>) -> Void
    ) {
        repository.searchStore(keyword: keyword) { result in
            switch result {
            case .success(let store):
                completion(.success(store))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
