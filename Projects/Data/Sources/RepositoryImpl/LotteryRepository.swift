//
//  LotteryRepository.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/15.
//

import Domain
import Foundation

public final class LotteryRepositoryImpl: LotteryRepository {
    
    private let dataStore: LotteryDataStore
    
    public init(dataStore: LotteryDataStore) {
        self.dataStore = dataStore
    }
    
    public func getLottery(
        turn: Int,
        completion: @escaping(Result<Lottery, Error>) -> Void
    ) {
        dataStore.getLottery(turn: turn) { result in
            switch result {
            case .success(let lottery):
                completion(.success(lottery.toDomain()))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
}
