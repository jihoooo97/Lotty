import Common
import CommonUI
import UIKit
import RxSwift

public final class LotteryListViewController: BaseViewController {

    private let viewModel: LotteryListViewModel
    
    public init(viewModel: LotteryListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    
    private let navigationBar = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var searchButton = UIButton()
    private lazy var lotteryTableView = LotteryTableView()
    
    private let refreshControl = UIRefreshControl()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        initAttributes()
        initConstraints()
        inputBind()
        outputBind()
    }

    
    private func inputBind() {
        searchButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind { 
                guard let injector = $0.injector else { return }
                let searchViewController = injector.resolve(LotterySearchViewController.self)
                $0.navigationController?.pushViewController(searchViewController, animated: true)
//                searchViewController?.setFirstInfo(lottery: <#T##Lottery#>)
//                $0.coordinator?.pushLotterySearchViewController(lottery: nil)
            }
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind(onNext: { vc in
                vc.viewModel.resetLotteryList()
            })
            .disposed(by: disposeBag)
        
        // MARK: [!] Section Sticky Header
        lotteryTableView.rx.didScroll
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .map { ($0, $0.lotteryTableView.contentOffset.y) }
            .bind(onNext: { vc, offset in
                let contentHeight = vc.lotteryTableView.contentSize.height
                let pagenationY = vc.lotteryTableView.frame.height

                if offset > contentHeight - pagenationY - 100  {
                    vc.viewModel.getMoreLotteryList()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func outputBind() {
        viewModel.isReload
            .withUnretained(self).map { $0.0 }
            .bind(onNext: { vc in
                vc.lotteryTableView.reloadData()
                vc.lotteryTableView.refreshControl?.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
    
    private func initAttributes() {
        titleLabel = {
            let label = UILabel()
            label.text = "조회하기"
            label.textAlignment = .center
            label.textColor = LottyColors.G900
            label.font = LottyFonts.bold(size: 18)
            return label
        }()
        
        searchButton = {
            let button = UIButton()
            button.tintColor = LottyColors.B500
            button.setImage(LottyIcons.search, for: .normal)
            return button
        }()
        
        lotteryTableView = {
            let tableView = LotteryTableView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.refreshControl = refreshControl
            return tableView
        }()
    }
    
    private func initConstraints() {
        [navigationBar, lotteryTableView].forEach {
            view.addSubview($0)
        }
        
        [titleLabel, searchButton].forEach {
            navigationBar.addSubview($0)
        }
        
        navigationBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeArea)
            $0.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        
        lotteryTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.equalTo(safeArea)
        }
    }
    
}

// MARK: 테이블뷰 DataSource
extension LotteryListViewController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.lotteryList.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lotteryList[section].isOpen ? 2 : 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: NumberCloseCell.cellId,
                for: indexPath
            ) as! NumberCloseCell
            
            cell.bind(lottery: viewModel.lotteryList[indexPath.section])
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: NumberCell.cellId, for: indexPath) as! NumberCell
            cell.setData(lottery: viewModel.lotteryList[indexPath.section])

            cell.detailButtonHandler = { [weak self] in
                guard let self = self,
                      let injector
                else { return }
                HapticManager.shared.hapticImpact(style: .soft)
                
                let lottery = self.viewModel.lotteryList[indexPath.section]
                let searchViewController = injector.resolve(LotterySearchViewController.self)
                searchViewController.setFirstInfo(lottery: lottery)
                self.navigationController?.pushViewController(searchViewController, animated: true)
//                self.coordinator?.pushLotterySearchViewController(lottery: lottery)
            }

            return cell
        }
    }

}

// MARK: 테이블뷰 Delegate
extension LotteryListViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 50
        default:
            return 220
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            viewModel.lotteryList[indexPath.section].isOpen.toggle()
            tableView.reloadSections([indexPath.section], with: .fade)

        default:
            return
        }
    }
    
}
