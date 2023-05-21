//
//  AroundCoordinatorProtocol.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import UIKit

protocol AroundCoordinator: Coordinator {
    func pushAroundViewController()
    func pushAroundSearchViewController()
}

final class DefaultAroundCoordinator: AroundCoordinator {

    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var injector: Injector
    var type: CoordinatorType { .around }
    
    
    required init(_ navigationController: UINavigationController, injector: Injector) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    
    func start() {
        pushAroundViewController()
    }
    
    func pushAroundViewController() {
        let aroundViewController = injector.resolve(AroundViewController.self)
        aroundViewController.coordinator = self
        self.navigationController.pushViewController(aroundViewController, animated: true)
    }
    
    func pushAroundSearchViewController() {        
        let aroundSearchCoordinator = DefaultAroundSearchCoordinator(
            self.navigationController,
            injector: injector
        )
        aroundSearchCoordinator.finishDelegate = self//.finishDelegate
        self.childCoordinators.append(aroundSearchCoordinator)
        aroundSearchCoordinator.start()
    }
    
}


extension DefaultAroundCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
        
        if childCoordinator.type == .around {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
}
