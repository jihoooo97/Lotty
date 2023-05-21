//
//  QRCoordinator.swift
//  Lotty
//
//  Created by 유지호 on 2023/05/21.
//

import UIKit

protocol QrScanCoordinator: Coordinator {
    func pushQrScanViewController()
}

final class DefaultQrScanCoordinator: QrScanCoordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var injector: Injector
    var type: CoordinatorType = .qr
    
    required init(_ navigationController: UINavigationController, injector: Injector) {
        self.navigationController = navigationController
        self.injector = injector
    }
    
    func start() {
        pushQrScanViewController()
    }
    
    func pushQrScanViewController() {
        let qrScanViewController = injector.resolve(QrScanViewController.self)
        qrScanViewController.coordinator = self
        self.navigationController.pushViewController(qrScanViewController, animated: true)
    }

}
