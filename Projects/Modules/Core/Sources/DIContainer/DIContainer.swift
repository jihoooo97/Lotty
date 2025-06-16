//
//  DIContainer.swift
//  Core
//
//  Created by 유지호 on 6/14/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Foundation

public final class DIContainer {
    
    public static let shared = DIContainer()
    
    private var services = [ObjectIdentifier: Any]()
    
    
    private init() { }
    
    
    // MARK: Register
    public func register<Service>(
        _ serviceType: Service.Type,
        _ factory: @escaping () -> Service
    ) {
        let key = ObjectIdentifier(serviceType)
        services[key] = factory
    }
    
    public func register<Service, Parameter>(
        _ serviceType: Service.Type,
        _ factory: @escaping (Parameter) -> Service
    ) {
        let key = ObjectIdentifier(serviceType)
        services[key] = factory
    }
    
    public func register<Service, Parameter1, Parameter2>(
        _ serviceType: Service.Type,
        _ factory: @escaping (Parameter1, Parameter2) -> Service
    ) {
        let key = ObjectIdentifier(serviceType)
        services[key] = factory
    }
    
    public func register<Service, Parameter1, Parameter2, Parameter3>(
        _ serviceType: Service.Type,
        _ factory: @escaping (Parameter1, Parameter2, Parameter3) -> Service
    ) {
        let key = ObjectIdentifier(serviceType)
        services[key] = factory
    }
    
    
    // MARK: Resolve
    public func resolve<Service>(_ serviceType: Service.Type) -> Service {
        let key = ObjectIdentifier(serviceType)
        
        guard let service = services[key] as? () -> Service else {
            preconditionFailure("\(serviceType) should be registered!")
        }
        
        return service()
    }
    
    public func resolve<Service, P>(_ serviceType: Service.Type, parameter: P) -> Service {
        let key = ObjectIdentifier(serviceType)
        
        guard let service = services[key] as? (P) -> Service else {
            preconditionFailure("\(serviceType) should be registered!")
        }
        
        return service(parameter)
    }
    
    public func resolve<Service, P1, P2>(
        _ serviceType: Service.Type,
        parameters p1: P1, _ p2: P2
    ) -> Service {
        let key = ObjectIdentifier(serviceType)
        
        guard let service = services[key] as? (P1, P2) -> Service else {
            preconditionFailure("\(serviceType) should be registered!")
        }
        
        return service(p1, p2)
    }
    
    public func resolve<Service, P1, P2, P3>(
        _ serviceType: Service.Type,
        parameters p1: P1, _ p2: P2, _ p3: P3
    ) -> Service {
        let key = ObjectIdentifier(serviceType)
        
        guard let service = services[key] as? (P1, P2, P3) -> Service else {
            preconditionFailure("\(serviceType) should be registered!")
        }
        
        return service(p1, p2, p3)
    }
    
}
