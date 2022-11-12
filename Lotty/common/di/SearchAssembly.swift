//
//  SearchContainer.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/12.
//

import Foundation
import Swinject

class SearchContainer: NSObject {
    
    let container = Container()
    
    override init() {
        
        container.register(LotterySearchViewModel.self) { _ in
            return LotterySearchViewModel()
        }
        
        let viewModel = container.resolve(LotterySearchViewModel.self)
        
    }
    
}

class SearchAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(LotterySearchViewModel.self) { _ in
            return LotterySearchViewModel()
        }
    }

}
