//
//  LotteryListCoordinator.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/23.
//

import UIKit

protocol LotteryListCoordinator: Coordinator {
    func pushLotteryListViewController()
    func pushLotterySearchViewController(lottery: Lottery?)
}

final class DefaultLotteryListCoordinator: LotteryListCoordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var injector: Injector
    var type: CoordinatorType { .search }
    
    required init(_ navigationController: UINavigationController, injector: Injector) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    func start() {
        pushLotteryListViewController()
    }
    
    func pushLotteryListViewController() {
        let lotteryListViewController = injector.resolve(LotteryListViewController.self)
        lotteryListViewController.coordinator = self
        self.navigationController.pushViewController(lotteryListViewController, animated: true)
    }
    
    func pushLotterySearchViewController(lottery: Lottery?) {
        let lotterySearchCoordinator = DefaultLotterySearchCoordinator(
            self.navigationController,
            injector: injector
        )
        lotterySearchCoordinator.finishDelegate = self
        self.childCoordinators.append(lotterySearchCoordinator)
        
        if let lottery {
            lotterySearchCoordinator.pushLotterySearchViewController(lottery: lottery)
        } else {
            lotterySearchCoordinator.pushLotterySearchViewController()
        }
    }
    
}


extension DefaultLotteryListCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
        
        if childCoordinator.type == .search {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
}
