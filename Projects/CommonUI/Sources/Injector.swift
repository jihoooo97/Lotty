//
//  Injector.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Swinject

public protocol Assemblable {
    func register<T>(_ serviceType: T.Type, _ object: T)
    func assemble(_ assemblies: [Assembly])
}

public protocol Resolvable {
    func resolve<T>(_ serviceTypeype: T.Type) -> T
}

public typealias Injector = Assemblable & Resolvable


public final class DependencyInjector: Injector {
    private let container: Container
    
    public init(container: Container) {
        self.container = container
    }
    
    
    // MARK: Assemblable
    public func register<T>(_ serviceType: T.Type, _ object: T) {
        container.register(serviceType) { resolver in
            object
        }
    }
    
    public func assemble(_ assemblies: [Assembly]) {
        assemblies.forEach {
            $0.assemble(container: container)
        }
    }
    
    
    // MARK: Resolvable
    public func resolve<T>(_ serviceType: T.Type) -> T {
        container.resolve(serviceType)!
    }
    
}
