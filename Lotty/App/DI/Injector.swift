//
//  Injector.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Swinject

protocol Assemblable {
    func register<T>(_ serviceType: T.Type, _ object: T)
    func assemble(_ assemblies: [Assembly])
}

protocol Resolvable {
    func resolve<T>(_ serviceTypeype: T.Type) -> T
}

typealias Injector = Assemblable & Resolvable


final class DependencyInjector: Injector {
    private let container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    
    // MARK: Assemblable
    func register<T>(_ serviceType: T.Type, _ object: T) {
        container.register(serviceType) { resolver in
            object
        }
    }
    
    func assemble(_ assemblies: [Assembly]) {
        assemblies.forEach {
            $0.assemble(container: container)
        }
    }
    
    
    // MARK: Resolvable
    func resolve<T>(_ serviceType: T.Type) -> T {
        container.resolve(serviceType)!
    }
    
}
