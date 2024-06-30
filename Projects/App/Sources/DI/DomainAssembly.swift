//
//  DomainAssembly.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Domain
import Swinject

final class DomainAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(StoreUseCase.self) { resolver in
            let repository = resolver.resolve(StoreRepository.self)!
            return StoreUseCaseImpl(repository: repository)
        }
        
        container.register(LotteryUseCase.self) { resolver in
            let repository = resolver.resolve(LotteryRepository.self)!
            return LotteryUseCaseImpl(repository: repository)
        }
        
        container.register(HistoryUseCase.self) { resolver in
            let repository = resolver.resolve(HistoryRepository.self)!
            return HistoryUseCaseImpl(repository: repository)
        }
        
        container.register(GameUseCase.self) { resolver in
            return GameUseCaseImpl()
        }
    }
    
}
