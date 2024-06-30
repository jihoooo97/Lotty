//
//  TabBarController.swift
//  Lotty
//
//  Created by 유지호 on 6/28/24.
//  Copyright © 2024 jiho. All rights reserved.
//

import Presentation
import CommonUI
import UIKit

enum Tab: String, CaseIterable {
    case around
    case search
    case qr
    case random
    
    init?(index: Int) {
        switch index {
        case 0: self = .around
        case 1: self = .search
        case 2: self = .qr
        case 3: self = .random
        default: return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .around: return 0
        case .search: return 1
        case .qr:     return 2
        case .random: return 3
        }
    }
    
    func tabTitle() -> String {
        switch self {
        case .around: return "내 주변"
        case .search: return "번호 조회"
        case .qr:     return "QR 스캔"
        case .random: return "번호 생성"
        }
    }
    
    func tabIcon() -> UIImage {
        switch self {
        case .around: return .init(named: "map_icon")!
        case .search: return .init(named: "find_icon")!
        case .qr:     return .init(named: "qr_scan_icon")!
        case .random: return .init(named: "slot_icon")!
        }
    }
}

final class TabBarController: UITabBarController {
    let injector: Injector

    
    init(injector: Injector) {
        self.injector = injector
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabs = Tab.allCases.map { makeTabNavigationController(of: $0) }
        initTabBarController(with: tabs)
    }
    
    
    private func initTabBarController(with tabViewControllers: [UIViewController]) {
        self.setViewControllers(tabViewControllers, animated: true)
        self.selectedIndex = Tab.around.pageOrderNumber()
        self.view.backgroundColor = .white
        self.tabBar.backgroundColor = .white
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = LottyColors.B500
    }
    
    private func initTabBarItem(of page: Tab) -> UITabBarItem {
        return .init(
            title: page.tabTitle(),
            image: page.tabIcon(),
            tag: page.pageOrderNumber()
        )
    }

    private func makeTabNavigationController(of page: Tab) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        tabNavigationController.tabBarItem = initTabBarItem(of: page)
        
        switch page {
        case .around:
            let aroundViewController = injector.resolve(AroundViewController.self)
            aroundViewController.injector = injector
            tabNavigationController.isNavigationBarHidden = true
            tabNavigationController.pushViewController(aroundViewController, animated: true)
        case .search:
            let lotteryViewController = injector.resolve(LotteryListViewController.self)
            lotteryViewController.injector = injector
            tabNavigationController.isNavigationBarHidden = true
            tabNavigationController.pushViewController(lotteryViewController, animated: true)
        case .qr:
            let qrViewController = injector.resolve(QrScanViewController.self)
            tabNavigationController.isNavigationBarHidden = true
            tabNavigationController.pushViewController(qrViewController, animated: true)
        case .random:
            let randomViewController = injector.resolve(RandomViewController.self)
            tabNavigationController.isNavigationBarHidden = true
            tabNavigationController.pushViewController(randomViewController, animated: true)
        }
        return tabNavigationController
    }
    
}
