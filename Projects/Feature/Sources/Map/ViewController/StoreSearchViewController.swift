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
import RxSwift
import RxRelay
import GoogleMobileAds

public final class StoreSearchViewController: BaseViewController {
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var tableViewHeader = SearchHistoryTableViewHeader(title: "최근 검색어")
    private lazy var tableView = UITableView()
    private lazy var bannerView = BannerView()
    
    private let onTapCell = PublishRelay<String>()
    private let onTapDeleteCell = PublishRelay<String>()
    private let onTapClearButton = PublishRelay<Void>()
    
    private let viewModel: StoreSearchViewModel
    
    public init(viewModel: StoreSearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchController.isActive = true
        
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    
    // 코드로 navigation pop시, 이전 뷰의 navigation bar 영역이 남아있는 것을 해결하기 위함
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let coordinator = transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            })
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    
    private func bindViewModel() {
        let input = StoreSearchViewModel.Input(
            viewDidLoad: Observable.just(()),
            searchTextfieldDidEdit: searchController.searchBar.rx.text.orEmpty.asObservable(),
            searchButtonDidTap: searchController.searchBar.rx.searchButtonClicked.asObservable(),
            searchHistoryDidTap: onTapCell.asObservable(),
            searchHistoryDeleteButtonDidTap: onTapDeleteCell.asObservable(),
            clearButtonDidTap: onTapClearButton.asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
        tableViewHeader.buttonAction = { [weak self] in
            HapticManager.run()
            
            self?.presentAlert(message: "최근검색어를 모두 삭제하시겠습니까?") { _ in
                self?.onTapClearButton.accept(())
                self?.searchController.isActive = false
            }
        }
        
        viewModel.onTapSearchButton = {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        output.searchHistory
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                cellIdentifier: SearchHistoryCell.identifier,
                cellType: SearchHistoryCell.self
            )) { [weak self] row, element, cell in
                cell.bind(
                    history: element,
                    contentAction: { self?.onTapCell.accept(element.keyword) },
                    deleteAction: { self?.onTapDeleteCell.accept(element.keyword) }
                )
            }.disposed(by: bag)
    }
    
    
    public override func setUIProperty() {
        searchController = {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchBar.placeholder = "지역 이름으로 검색하세요."
            controller.searchBar.searchTextField.font = .systemFont(ofSize: 16.0, weight: .medium)
            controller.searchBar.searchTextField.autocorrectionType = .no
            controller.searchBar.searchTextField.autocapitalizationType = .none
            controller.searchBar.searchTextField.spellCheckingType = .no
            return controller
        }()
                
        tableView = {
            let tableView = UITableView()
            tableView.separatorStyle = .none
            tableView.keyboardDismissMode = .onDrag
            tableView.showsHorizontalScrollIndicator = false
            tableView.rowHeight = 40
            tableView.register(SearchHistoryCell.self, forCellReuseIdentifier: SearchHistoryCell.identifier)
            return tableView
        }()
        
        bannerView = {
            let banner = BannerView()
            
            #if DEBUG
            banner.adUnitID = "ca-app-pub-3940256099942544/2435281174"
            #else
            banner.adUnitID = "ca-app-pub-1763854291067764/5550226990"
            #endif
            
            banner.rootViewController = self
            banner.load(Request())
            return banner
        }()
        
        self.navigationItem.title = "판매점 검색"
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    public override func setLayout() {
        view.addSubviews(tableViewHeader, tableView, bannerView)
        
        tableViewHeader.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeArea)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeArea)
            make.top.equalTo(tableViewHeader.snp.bottom)
            make.bottom.equalTo(bannerView.snp.top)
        }
        
        bannerView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(safeArea)
            make.height.equalTo(56)
        }
    }
    
}
