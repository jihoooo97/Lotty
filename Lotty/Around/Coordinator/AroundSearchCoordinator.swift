//
//  AroundSearchCoordinator.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import UIKit

protocol AroundSearchCoordinator: Coordinator {
    func pushAroundSearchViewController()
}

final class DefaultAroundSearchCoordinator: AroundSearchCoordinator {
    
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
        pushAroundSearchViewController()
    }
    
    func pushAroundSearchViewController() {
        guard let aroundViewController = navigationController
            .viewControllers
            .compactMap({ $0 as? AroundViewController })
            .first
        else { return }
        
        let aroundSearchViewController = injector.resolve(AroundSearchViewController.self)
        aroundSearchViewController.coordinator = self
        aroundSearchViewController.delegate = aroundViewController
        self.navigationController.pushViewController(aroundSearchViewController, animated: true)
    }
    
}
