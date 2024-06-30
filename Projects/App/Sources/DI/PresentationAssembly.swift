//
//  PresentationAssembly.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Domain
import Presentation
import Swinject

class PresentationAssembly: Assembly {
    
    func assemble(container: Container) {
        // MARK: Around
        container.register(AroundViewModel.self) { resolver in
            let useCase = resolver.resolve(StoreUseCase.self)!
            return AroundViewModel(useCase: useCase)
        }
        
        container.register(AroundViewController.self) { resolver in
            let viewModel = resolver.resolve(AroundViewModel.self)!
            return AroundViewController(viewModel: viewModel)
        }
        
        container.register(AroundSearchViewModel.self) { resolver in
            let useCase = resolver.resolve(HistoryUseCase.self)!
            return AroundSearchViewModel(useCase: useCase)
        }
        
        container.register(AroundSearchViewController.self) { resolver in
            let viewModel = resolver.resolve(AroundSearchViewModel.self)!
            return AroundSearchViewController(viewModel: viewModel)
        }
        
        // MARK: Search
        container.register(LotteryListViewModel.self) { resolver in
            let useCase = resolver.resolve(LotteryUseCase.self)!
            return LotteryListViewModel(useCase: useCase)
        }
        
        container.register(LotteryListViewController.self) { resolver in
            let viewModel = resolver.resolve(LotteryListViewModel.self)!
            return LotteryListViewController(viewModel: viewModel)
        }
        
        container.register(LotterySearchViewModel.self) { resolver in
            let lotteryUseCase = resolver.resolve(LotteryUseCase.self)!
            let historyUseCase = resolver.resolve(HistoryUseCase.self)!
            return LotterySearchViewModel(
                lotteryUseCase: lotteryUseCase,
                historyUseCase: historyUseCase
            )
        }

        container.register(LotterySearchViewController.self) { resolver in
            let viewModel = resolver.resolve(LotterySearchViewModel.self)!
            return LotterySearchViewController(viewModel: viewModel)
        }
        
        // MARK: QR
        container.register(QRScanViewModel.self) { resolver in
            return QRScanViewModel()
        }
        
        container.register(QrScanViewController.self) { resolver in
            let viewModel = resolver.resolve(QRScanViewModel.self)!
            return QrScanViewController(viewModel: viewModel)
        }
        
        //MARK: Random
        container.register(RandomViewModel.self) { resolver in
            let useCase = resolver.resolve(GameUseCase.self)!
            return RandomViewModel(useCase: useCase)
        }
        
        container.register(RandomViewController.self) { resolver in
            let viewModel = resolver.resolve(RandomViewModel.self)!
            return RandomViewController(viewModel: viewModel)
        }
    }

}
