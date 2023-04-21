//
//  AppCoordinator.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import UIKit

protocol AppCoordinator: Coordinator {
//    func showLoginFlow()
    func showTabBarFlow()
}

final class LottyAppCoordinator: AppCoordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var injector: Injector
    var type: CoordinatorType { .app }
    
    
    required init(_ navigationController: UINavigationController, injector: Injector) {
        self.navigationController = navigationController
        self.injector = injector
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    
    func start() {
        showTabBarFlow()
    }
    
    func showTabBarFlow() {
        let tabBarCoordinator = LottyTabBarCoordinator(navigationController, injector: injector)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
        childCoordinators.append(tabBarCoordinator)
    }
    
}


extension LottyAppCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter {
            $0.type != childCoordinator.type
        }
        
        self.navigationController.view.backgroundColor = .white
        self.navigationController.viewControllers.removeAll()
        
        switch childCoordinator.type {
        case .tab:
            showTabBarFlow()
        default:
            break
        }
    }
    
}
