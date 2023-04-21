//
//  RandomAssembly.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Swinject

class RandomAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(RandomViewModel.self) { resolver in
            let usecase = resolver.resolve(GameUsecase.self)!
            return RandomViewModel(usecase: usecase)
        }
        
        container.register(RandomViewController.self) { resolver in
            let viewModel = resolver.resolve(RandomViewModel.self)!
            return RandomViewController(viewModel: viewModel)
        }
    }
    
}
