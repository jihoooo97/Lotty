//
//  TabBarController.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/07.
//

import UIKit

class TabBarController: UITabBarController {

    let aroundView = AroundViewController()
    let searchView = LotteryListViewController()
    let qrView = QrScanViewController()
    let randomView = RandomViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabbarItems()
        initUI()
    }

    private func setTabbarItems() {
        aroundView.tabBarItem.badgeColor = UIColor(named: "B500")!
        aroundView.tabBarItem.image = UIImage(named: "map_icon")!
        aroundView.title = "내 주변"
        
        searchView.tabBarItem.badgeColor = UIColor(named: "B500")!
        searchView.tabBarItem.image = UIImage(named: "find_icon")!
        searchView.title = "번호 조회"
        
        qrView.tabBarItem.badgeColor = UIColor(named: "B500")!
        qrView.tabBarItem.image = UIImage(named: "qr_scan_icon")!
        qrView.title = "QR 코드"
        
        randomView.tabBarItem.badgeColor = UIColor(named: "B500")!
        randomView.tabBarItem.image = UIImage(named: "slot_icon")!
        randomView.title = "번호 생성"
        
        setViewControllers([aroundView, searchView, qrView, randomView], animated: false)
    }
    
    private func initUI() {
//        tabBar.backgroundColor = .white
//        tabBar.tintColor = .white
        tabBarController?.tabBar.backgroundColor = .white
        tabBarController?.tabBar.tintColor = .white
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
}
