//
//  LotterySearchViewController.swift
//  SearchFeature
//
//  Created by 유지호 on 6/18/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import UIComponent

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import GoogleMobileAds

public final class LotterySearchViewController: BaseViewController {

    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var stackView = UIStackView()
    private lazy var drawNoLabel = UILabel()
    private let lotteryInfoView = LotteryInfoView()
    
    private lazy var tableViewHeader = SearchHistoryTableViewHeader(title: "최근 본 회차")
    private lazy var tableView = UITableView()
    private lazy var bannerView = BannerView()
    
    private let onTapCell = PublishRelay<String>()
    private let onTapDeleteCell = PublishRelay<String>()
    private let onTapClearButton = PublishRelay<Void>()
    
    private let viewModel: LotterySearchViewModel
    
    public init(viewModel: LotterySearchViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchController.isActive = true
        
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    
    private func bindViewModel() {
        let input = LotterySearchViewModel.Input(
            viewDidLoad: Observable.just(()),
            searchFieldDidChange: searchController.searchBar.rx.text.orEmpty.asObservable(),
            searchHistoryDidTap: onTapCell.asObservable(),
            searchHistoryDeleteButtonDidTap: onTapDeleteCell.asObservable(),
            clearButtonDidTap: onTapClearButton.asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
        output.searchResult
            .asDriver(onErrorJustReturn: nil)
            .drive { [weak self] lottery in
                guard let lottery else {
                    self?.lotteryInfoView.isHidden = true
                    return
                }
                
                self?.drawNoLabel.text = lottery.drawNo.formatted() + "회"
                self?.lotteryInfoView.configure(with: lottery)
                self?.lotteryInfoView.isHidden = false
                self?.searchController.searchBar.text?.removeAll()
            }.disposed(by: bag)
        
        tableViewHeader.buttonAction = { [weak self] in
            HapticManager.run()
            
            self?.presentAlert(message: "최근 본 회차를 모두 삭제하시겠습니까?") { _ in
                self?.onTapClearButton.accept(())
                self?.searchController.isActive = false
            }
        }
        
        output.searchHistory
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                cellIdentifier: SearchHistoryCell.identifier,
                cellType: SearchHistoryCell.self
            )) { [weak self] row, item, cell in
                cell.bind(
                    history: item,
                    contentAction: { self?.onTapCell.accept(item.keyword) },
                    deleteAction: { self?.onTapDeleteCell.accept(item.keyword) }
                )
            }.disposed(by: bag)
    }
    
    public override func setUIProperty() {
        searchController = {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchBar.placeholder = "회차를 검색하세요. ex) 1000"
            controller.searchBar.searchTextField.font = .systemFont(ofSize: 16.0, weight: .medium)
            controller.searchBar.searchTextField.autocorrectionType = .no
            controller.searchBar.searchTextField.autocapitalizationType = .none
            controller.searchBar.searchTextField.spellCheckingType = .no
            controller.searchBar.keyboardType = .numberPad
            return controller
        }()
                
        stackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            return stackView
        }()
        
        drawNoLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 18.0, weight: .semibold)
            label.textAlignment = .left
            return label
        }()
        
        lotteryInfoView.isHidden = true
        
        tableView = {
            let tableView = UITableView()
            tableView.separatorStyle = .none
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
        
        self.navigationItem.title = "회차 검색"
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    public override func setLayout() {
        let dividor = UIView()
        dividor.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        view.addSubviews(stackView, dividor, tableViewHeader, tableView, bannerView)
        stackView.addArrangedSubviews(drawNoLabel, lotteryInfoView)
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeArea).inset(20)
        }
        
        dividor.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeArea)
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        
        tableViewHeader.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeArea)
            make.top.equalTo(dividor.snp.bottom).offset(8)
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
