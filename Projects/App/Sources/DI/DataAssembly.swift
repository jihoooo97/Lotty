//
//  DataAssembly.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Data
import Domain
import Swinject

final class DataAssembly: Assembly {
    
    func assemble(container: Container) {
        // MARK: Store
        container.register(StoreDataStore.self) { resolver in
            return StoreDataStore()
        }
        container.register(StoreRepository.self) { resolver in
            let dataStore = resolver.resolve(StoreDataStore.self)!
            return StoreRepositoryImpl(dataStore: dataStore)
        }
        
        // MARK: Lottery
        container.register(LotteryDataStore.self) { resolver in
            return LotteryDataStore()
        }
        
        container.register(LotteryRepository.self) { resolver in
            let dataStore = resolver.resolve(LotteryDataStore.self)!
            return LotteryRepositoryImpl(dataStore: dataStore)
        }
        
        // MARK: History
        container.register(HistoryRepository.self) { resolver in
            return HistoryRepositoryImpl()
        }
    }
    
}
