//
//  StoreDataStore.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import Foundation

class StoreDataStore {

    init() { }
    
    func getStoreList(
        x: Double,
        y: Double,
        completion: @escaping(Result<StoreDTO, Error>) -> Void
    ) {
        API.session.request(
            StoreAPI.getStoreList(x: x, y: y),
            interceptor: LottyRequestInterceptor()
        ).responseDecodable(of: StoreDTO.self) { response in
            switch response.result {
            case .success(let storeList):
                completion(.success(storeList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchStore(
        keyword: String,
        completion: @escaping(Result<StoreDTO, Error>) -> Void
    ) {
        API.session.request(
            StoreAPI.searchStore(keyword: keyword),
            interceptor: LottyRequestInterceptor()
        ).responseDecodable(of: StoreDTO.self) { response in
            switch response.result {
            case .success(let storeList):
                completion(.success(storeList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
