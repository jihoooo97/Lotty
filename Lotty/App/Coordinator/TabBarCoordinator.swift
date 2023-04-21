//
//  TabBarCoordinator.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import UIKit

enum TabBarPage: String, CaseIterable {
    case around, search, qr, random
    
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
        case .qr: return 2
        case .random: return 3
        }
    }
    
    func tabBarTitle() -> String {
        switch self {
        case .around:
            return "내 주변"
        case .search:
            return "번호 조회"
        case .qr:
            return "QR 스캔"
        case .random:
            return "번호 생성"
        }
    }
    
    func tabBarIcon() -> UIImage {
        switch self {
        case .around:
            return UIImage(named: "map_icon")!
        case .search:
            return UIImage(named: "find_icon")!
        case .qr:
            return UIImage(named: "qr_scan_icon")!
        case .random:
            return UIImage(named: "slot_icon")!
        }
    }
}

protocol TabBarCoordinator: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

final class LottyTabBarCoordinator: NSObject, TabBarCoordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var tabBarController: UITabBarController
    var injector: Injector
    var type: CoordinatorType { .tab }
    
    
    required init(_ navigationController: UINavigationController, injector: Injector) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.injector = injector
        super.init()
    }
    
    
    func start() {
        let pages: [TabBarPage] = TabBarPage.allCases
        let controllers: [UINavigationController] = pages.map {
            makeTabNavigationController(of: $0)
        }
        initTabBarController(with: controllers)
    }
    
    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage(index: index) else { return }
        tabBarController.selectedIndex = page.pageOrderNumber()

    }
    
    func currentPage() -> TabBarPage? {
        TabBarPage(index: tabBarController.selectedIndex)
    }
 
    
    private func initTabBarController(with tabViewControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabViewControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.around.pageOrderNumber()
        tabBarController.view.backgroundColor = .white
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = LottyColors.B500
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    private func initTabBarItem(of page: TabBarPage) -> UITabBarItem {
        return .init(
            title: page.tabBarTitle(),
            image: page.tabBarIcon(),
            tag: page.pageOrderNumber()
        )
    }
    
    private func makeTabNavigationController(of page: TabBarPage) -> UINavigationController {
        let tabNavigationController = NavigationController()
        tabNavigationController.tabBarItem = initTabBarItem(of: page)
        
        startTabBarCoordinator(of: page, to: tabNavigationController)
        return tabNavigationController
    }
    
    private func startTabBarCoordinator(
        of page: TabBarPage,
        to tabNavigationController: UINavigationController
    ) {
        switch page {
        case .around:
            let aroundCoordinator = DefaultAroundCoordinator(
                tabNavigationController,
                injector: injector
            )
            aroundCoordinator.finishDelegate = self
            self.childCoordinators.append(aroundCoordinator)
            aroundCoordinator.start()
            
        case .search:
            let lotteryListViewController = injector.resolve(LotteryListViewController.self)
            tabNavigationController.pushViewController(lotteryListViewController, animated: true)
        case .qr:
            let qrViewController = injector.resolve(QrScanViewController.self)
            tabNavigationController.pushViewController(qrViewController, animated: true)
        case .random:
            let randomViewController = injector.resolve(RandomViewController.self)
            tabNavigationController.pushViewController(randomViewController, animated: true)
        }
    }
    
}


extension LottyTabBarCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
        
    }
}
