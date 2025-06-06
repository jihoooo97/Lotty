import BaseFeature
import MapFeature

import UIKit

public final class TabViewController: UITabBarController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabs = Tab.allCases.map { makeTabNavigationController(of: $0) }
        initTabBarController(with: tabs)
    }
    
    
    private func initTabBarController(with tabViewControllers: [UIViewController]) {
        self.setViewControllers(tabViewControllers, animated: true)
        self.selectedIndex = Tab.map.pageOrderNumber()
        self.view.backgroundColor = .white
        self.tabBar.backgroundColor = .white
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = .tintColor
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
        case .map:
            let mapViewController = LottyMapViewController()
            mapViewController.view.backgroundColor = .white
//            tabNavigationController.isNavigationBarHidden = true
            tabNavigationController.pushViewController(mapViewController, animated: true)
        case .search:
            let lotteryViewController = BaseViewController()
            lotteryViewController.view.backgroundColor = .white
//            tabNavigationController.isNavigationBarHidden = true
            tabNavigationController.pushViewController(lotteryViewController, animated: true)
        case .qr:
            let qrViewController = BaseViewController()
            qrViewController.view.backgroundColor = .white
//            tabNavigationController.isNavigationBarHidden = true
            tabNavigationController.pushViewController(qrViewController, animated: true)
        case .random:
            let randomViewController = BaseViewController()
            randomViewController.view.backgroundColor = .white
//            tabNavigationController.isNavigationBarHidden = true
            tabNavigationController.pushViewController(randomViewController, animated: true)
        }
        return tabNavigationController
    }
}


enum Tab: String, CaseIterable {
    case map
    case search
    case qr
    case random
    
    init?(index: Int) {
        switch index {
        case 0: self = .map
        case 1: self = .search
        case 2: self = .qr
        case 3: self = .random
        default: return nil
        }
    }
    
    func pageOrderNumber() -> Int {
        switch self {
        case .map: return 0
        case .search: return 1
        case .qr:     return 2
        case .random: return 3
        }
    }
    
    func tabTitle() -> String {
        switch self {
        case .map: return "내 주변"
        case .search: return "번호 조회"
        case .qr:     return "QR 스캔"
        case .random: return "번호 생성"
        }
    }
    
    func tabIcon() -> UIImage {
        switch self {
        case .map: return .init(systemName: "globe")!
        case .search: return .init(systemName: "globe")!
        case .qr:     return .init(systemName: "globe")!
        case .random: return .init(systemName: "globe")!
        }
    }
}
