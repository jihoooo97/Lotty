//
//  StoreSearchViewController.swift
//  MapFeature
//
//  Created by 유지호 on 6/6/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import BaseFeature
import Core
import UIComponent

import UIKit

final class StoreSearchViewController: BaseViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
//    private lazy var navigationBar = UIStackView()
//    private lazy var backButton = UIButton(configuration: .plain())
//    private lazy var searchBar = UISearchBar()
    
    
    override init() {
        super.init()
        searchController.searchBar.placeholder = "지역 이름으로 검색하세요."
        searchController.searchResultsUpdater = self
        self.navigationItem.title = "판매점 검색"
        self.navigationItem.searchController = searchController
    }
    
    
    override func setUIProperty() {
//        navigationBar = {
//            let stackView = UIStackView()
//            stackView.axis = .horizontal
//            stackView.distribution = .fillProportionally
//            stackView.alignment = .leading
//            return stackView
//        }()
//        
//        backButton.configuration?.image = .init(systemName: "chevron.left")
//        backButton.tintColor = .tintColor
    }
    
    override func setLayout() {
        
    }
    
}


extension StoreSearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}
