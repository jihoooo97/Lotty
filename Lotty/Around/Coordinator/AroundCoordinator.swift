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
        guard let aroundViewController = navigationController
            .viewControllers
            .compactMap({ $0 as? AroundViewController })
            .first
        else { return }
        
        let aroundSearchViewController = injector.resolve(AroundSearchViewController.self)
        aroundSearchViewController.delegate = aroundViewController
        self.navigationController.pushViewController(aroundSearchViewController, animated: true)
    }
    
}
