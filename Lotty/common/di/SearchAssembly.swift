//
//  SearchContainer.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/12.
//

import Foundation
import Swinject

class SearchAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(LotterySearchViewModel.self) { r in
            LotterySearchViewModel()
        }
        
        container.register(LotterySearchViewController.self) { r in
            let viewController = LotterySearchViewController()
            viewController.viewModel = r.resolve(LotterySearchViewModel.self)
            return viewController
        }
    }

}
