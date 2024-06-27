//
//  AroundAssembly.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Swinject

class AroundAssembly: Assembly {
    
    func assemble(container: Container) {
        // MARK: Around
        container.register(AroundViewModel.self) { resolver in
            let uscase = resolver.resolve(StoreUsecase.self)!
            return AroundViewModel(usecase: uscase)
        }
        
        container.register(AroundViewController.self) { resolver in
            let viewModel = resolver.resolve(AroundViewModel.self)!
            return AroundViewController(viewModel: viewModel)
        }
        
        // MARK: AroundSearch
        container.register(AroundSearchViewModel.self) { resolver in
            let usecase = resolver.resolve(HistoryUsecase.self)!
            return AroundSearchViewModel(usecase: usecase)
        }
        
        container.register(AroundSearchViewController.self) { resolver in
            let viewModel = resolver.resolve(AroundSearchViewModel.self)!
            return AroundSearchViewController(viewModel: viewModel)
        }
    }

}
