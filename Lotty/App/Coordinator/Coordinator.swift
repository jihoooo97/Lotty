//
//  Coordinator.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import UIKit

enum CoordinatorType {
    case app, tab
    case around, search, qr, random
}

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(childCoordinator: Coordinator)
}

protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var injector: Injector { get }
    var type: CoordinatorType { get }
    
    init(_ navigationController: UINavigationController, injector: Injector)
    
    func start()
    func finish()
    func findCoordinator(type: CoordinatorType) -> Coordinator?
}


extension Coordinator {
    
    func finish() {
        childCoordinators.removeAll()
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    func findCoordinator(type: CoordinatorType) -> Coordinator? {
        var stack: [Coordinator] = [self]
        
        while !stack.isEmpty {
            let currentCoordinator = stack.removeLast()
            if currentCoordinator.type == type {
                return currentCoordinator
            }
            
            currentCoordinator.childCoordinators.forEach {
                stack.append($0)
            }
        }
        return nil
    }
}
