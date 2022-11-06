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
    let randomView = RandomViewController()
    let qrView = QrScanViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTabbarItems()
        initUI()
    }

    private func setTabbarItems() {
        aroundView.tabBarItem.image = UIImage(named: "map_icon")!
        searchView.tabBarItem.image = UIImage(named: "find_icon")!
        randomView.tabBarItem.image = UIImage(named: "slot_icon")!
        qrView.tabBarItem.image = UIImage(named: "qr_scan_icon")!
        
        setViewControllers([aroundView, searchView, randomView, qrView], animated: false)
    }
    
    private func initUI() {
        
    }
    
}
