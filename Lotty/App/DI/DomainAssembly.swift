//
//  DomainAssembly.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Swinject

class DomainAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StoreUsecase.self) { resolver in
            let repository = resolver.resolve(StoreRepository.self)!
            return StoreUsecase(repository: repository)
        }
        
        container.register(LotteryUsecase.self) { resolver in
            let repository = resolver.resolve(LotteryRepository.self)!
            return LotteryUsecase(repository: repository)
        }
        
        container.register(HistoryUsecase.self) { resolver in
            let repository = resolver.resolve(HistoryRepository.self)!
            return HistoryUsecase(repository: repository)
        }
        
        container.register(GameUsecase.self) { resolver in
            return GameUsecase()
        }
    }
}
