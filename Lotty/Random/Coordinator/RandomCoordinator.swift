//
//  RandomCoordinator.swift
//  Lotty
//
//  Created by 유지호 on 2023/05/21.
//

import UIKit

protocol RandomCoordinator: Coordinator {
    func pushRandomViewController()
}

final class DefaultRandomCoordinator: RandomCoordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var injector: Injector
    var type: CoordinatorType = .random
    
    init(_ navigationController: UINavigationController, injector: Injector) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    func start() {
        pushRandomViewController()
    }
    
    func pushRandomViewController() {
        let randomViewController = injector.resolve(RandomViewController.self)
        self.navigationController.pushViewController(randomViewController, animated: true)
    }
}
