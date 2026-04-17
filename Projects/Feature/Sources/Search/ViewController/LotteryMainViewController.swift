import BaseFeature
import Core
import UIComponent

import UIKit
import RxSwift
import RxCocoa

public final class LotteryMainViewController: BaseViewController {

    private lazy var searchButton = UIBarButtonItem()
    private lazy var qrButton = UIBarButtonItem()
    private lazy var lotteryTableView = UITableView()
    
    private let refreshControll = UIRefreshControl()
    
    private let fetchLotteryList = PublishRelay<Void>()

    public weak var builder: SearchFeatureBuilder?
    private let viewModel: LotteryMainViewModel
    
    public init(builder: SearchFeatureBuilder, viewModel: LotteryMainViewModel) {
        self.builder = builder
        self.viewModel = viewModel
        super.init()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    
    private func bindViewModel() {
        let input = LotteryMainViewModel.Input(
            tableViewDidRefresh: refreshControll.rx.controlEvent(.valueChanged).asObservable(),
            tableViewDidScroll: fetchLotteryList.asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
        searchButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                HapticManager.run()
                
                guard let searchViewController = self?.builder?.buildLotterySearchVC() else { return }
                self?.navigationController?.pushViewController(searchViewController, animated: true)
            }.disposed(by: bag)
        
        qrButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                HapticManager.run()

                self?.present(QRViewController(), animated: true)
            }.disposed(by: bag)
        
        lotteryTableView.rx.itemSelected
            .asDriver()
            .drive { [weak self] indexPath in
                HapticManager.run(style: .light)
                self?.viewModel.toggleItem(with: output, at: indexPath.row)
                self?.lotteryTableView.reloadRows(at: [indexPath], with: .none)
            }.disposed(by: bag)
        
        lotteryTableView.rx.contentOffset
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { [weak self] offset in
                let contentHeight = self?.lotteryTableView.contentSize.height ?? .zero
                let tableViewHeight = self?.lotteryTableView.frame.height ?? 0
                return offset.y > contentHeight - tableViewHeight - 100
            }
            .asDriver(onErrorJustReturn: false)
            .filter { $0 }
            .drive { [weak self] _ in
                self?.fetchLotteryList.accept(())
            }.disposed(by: bag)
        
        output.lotteryList
            .asDriver(onErrorJustReturn: [])
            .drive(lotteryTableView.rx.items(cellIdentifier: LotteryCell.identifier, cellType: LotteryCell.self)) { row, item, cell in
                cell.configure(with: item)
            }.disposed(by: bag)
        
        output.isLoading
            .asDriver(onErrorJustReturn: true)
            .filter { !$0 }
            .drive { [weak self] _ in
                self?.refreshControll.endRefreshing()
            }.disposed(by: bag)
    }
    
    public override func setUIProperty() {
        searchButton = {
            let button = UIBarButtonItem()
            button.image = .init(systemName: "magnifyingglass")
            return button
        }()
        
        qrButton = {
            let button = UIBarButtonItem()
            button.image = .init(systemName: "qrcode.viewfinder")
            return button
        }()
        
        lotteryTableView = {
            let tableView = UITableView()
            tableView.separatorStyle = .none
            tableView.rowHeight = UITableView.automaticDimension
            tableView.contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
            tableView.refreshControl = refreshControll
            tableView.refreshControl?.tintColor = .tintColor.withAlphaComponent(0.5)
            tableView.register(LotteryCell.self, forCellReuseIdentifier: LotteryCell.identifier)
            return tableView
        }()
        
        self.navigationItem.rightBarButtonItems = [searchButton, qrButton]
        self.navigationController?.navigationBar.barTintColor = .systemBackground
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    public override func setLayout() {
        view.addSubviews(lotteryTableView)
        
        lotteryTableView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(safeArea)
            make.bottom.equalTo(safeArea).offset(8)
        }
    }

}
