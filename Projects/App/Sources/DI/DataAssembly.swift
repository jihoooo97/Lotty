//
//  DataAssembly.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Data
import Swinject

final class DataAssembly: Assembly {
    
    func assemble(container: Container) {
        // MARK: Store
        container.register(StoreDataStore.self) { resolver in
            return StoreDataStore()
        }
        container.register(StoreRepositoryImpl.self) { resolver in
            let dataStore = resolver.resolve(StoreDataStore.self)!
            return StoreRepositoryImpl(dataStore: dataStore)
        }
        
        // MARK: Lottery
        container.register(LotteryDataStore.self) { resolver in
            return LotteryDataStore()
        }
        
        container.register(LotteryRepositoryImpl.self) { resolver in
            let dataStore = resolver.resolve(LotteryDataStore.self)!
            return LotteryRepositoryImpl(dataStore: dataStore)
        }
        
        // MARK: History
        container.register(HistoryRepositoryImpl.self) { resolver in
            return HistoryRepositoryImpl()
        }
    }
    
}
