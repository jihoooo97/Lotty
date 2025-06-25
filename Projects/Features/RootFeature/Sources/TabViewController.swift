import Core
import Domain

import BaseFeature
import MapFeature
import SearchFeature
import RandomFeature

import UIKit

public final class TabViewController: UITabBarController {
    
    private let mapFeatureBuilder = MapFeatureBuilder()
    private let searchFeatureBuilder = SearchFeatureBuilder()
    
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
        self.selectedIndex = Tab.search.pageOrderNumber
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.cornerRadius = 12
        self.tabBar.applyShadow()
        self.tabBar.tintColor = .tintColor
        self.tabBar.backgroundImage = .init()
        self.tabBar.shadowImage = .init()
    }
    
    private func initTabBarItem(of page: Tab) -> UITabBarItem {
        return .init(
            title: page.tabTitle,
            image: page.tabIcon,
            tag: page.pageOrderNumber
        )
    }
    
    private func makeTabNavigationController(of page: Tab) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        tabNavigationController.tabBarItem = initTabBarItem(of: page)
        tabNavigationController.isNavigationBarHidden = true
        
        switch page {
        case .search:
            let lotteryViewController = searchFeatureBuilder.buildLotteryMainVC(builder: searchFeatureBuilder)
            tabNavigationController.isNavigationBarHidden = false
            tabNavigationController.pushViewController(lotteryViewController, animated: true)
        case .map:
            let mapViewController = mapFeatureBuilder.buildLottyMapVC(builder: mapFeatureBuilder)
            tabNavigationController.pushViewController(mapViewController, animated: true)
        case .random:
            let randomViewController = DrawViewController(viewModel: DrawViewModel())
            tabNavigationController.pushViewController(randomViewController, animated: true)
        }
        
        return tabNavigationController
    }
}


enum Tab: String, CaseIterable {
    case search
    case map
    case random
    
    init?(index: Int) {
        switch index {
        case 0: self = .search
        case 1: self = .map
        case 2: self = .random
        default: return nil
        }
    }
    
    var pageOrderNumber: Int {
        switch self {
        case .search: return 0
        case .map: return 1
        case .random: return 2
        }
    }
    
    var tabTitle: String {
        switch self {
        case .search: return "번호 조회"
        case .map: return "내 주변"
        case .random: return "번호 생성"
        }
    }
    
    var tabIcon: UIImage {
        switch self {
        case .search: return .init(systemName: "list.number")!
        case .map: return .init(systemName: "map")!
        case .random: return .init(systemName: "circle.hexagonpath")!
        }
    }
}
