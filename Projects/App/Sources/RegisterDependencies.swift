//
//  RegisterDependencies.swift
//  Lotty
//
//  Created by 유지호 on 6/14/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import Domain
import Networks

import MapFeature

import Foundation

extension SceneDelegate {
    
    var container: DIContainer {
        DIContainer.shared
    }
    
    func registerDependencies() {
        container.register(StoreMapper.self) {
            return StoreMapperImpl(service: DefaultStoreService())
        }
        
        container.register(StoreUsecase.self) { [unowned self] in
            let usecase = DefaultStoreUsecase(mapper: self.container.resolve(StoreMapper.self))
            return usecase
        }
    }
    
}
