//
//  SearchAssembly.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Swinject

class SearchAssembly: Assembly {

    func assemble(container: Container) {
        // MARK: LotteryList
        container.register(LotteryListViewModel.self) { resolver in
            let usecase = resolver.resolve(LotteryUsecase.self)!
            return LotteryListViewModel(usecase: usecase)
        }
        
        container.register(LotteryListViewController.self) { resolver in
            let viewModel = resolver.resolve(LotteryListViewModel.self)!
            return LotteryListViewController(viewModel: viewModel)
        }
        
        // MARK: LotterySearch
        container.register(LotterySearchViewModel.self) { resolver in
            let lotteryUsecase = resolver.resolve(LotteryUsecase.self)!
            let historyUsecase = resolver.resolve(HistoryUsecase.self)!
            return LotterySearchViewModel(
                lotteryUsecase: lotteryUsecase,
                historyUsecase: historyUsecase
            )
        }
        
        container.register(LotterySearchViewController.self) { resolver in
            let viewModel = resolver.resolve(LotterySearchViewModel.self)!
            return LotterySearchViewController(viewModel: viewModel)
        }
    }
    
}
