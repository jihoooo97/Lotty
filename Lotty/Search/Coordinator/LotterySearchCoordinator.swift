//
//  LotterySearchCoordinator.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/23.
//

import UIKit

protocol LotterySearchCoordinator: Coordinator {
    func pushLotterySearchViewController()
    func pushLotterySearchViewController(lottery: Lottery)
}

final class DefaultLotterySearchCoordinator: LotterySearchCoordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var injector: Injector
    var type: CoordinatorType { .search }
    
    
    required init(_ navigationController: UINavigationController, injector: Injector) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    
    func start() { }
    
    func pushLotterySearchViewController() {
        let lotterySearchViewController = injector.resolve(LotterySearchViewController.self)
        lotterySearchViewController.coordinator = self
        lotterySearchViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(lotterySearchViewController, animated: true)
    }
    
    func pushLotterySearchViewController(lottery: Lottery) {
        let lotterySearchViewController = injector.resolve(LotterySearchViewController.self)
        lotterySearchViewController.coordinator = self
        lotterySearchViewController.hidesBottomBarWhenPushed = true
        lotterySearchViewController.setFirstInfo(lottery: lottery)
        self.navigationController.pushViewController(lotterySearchViewController, animated: true)
    }
    
}
