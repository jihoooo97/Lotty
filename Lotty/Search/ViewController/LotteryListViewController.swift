import UIKit
import RxSwift
import RxCocoa

final class LotteryListViewController: UIViewController {

    weak var coordinator: LotteryListCoordinator?
    private let viewModel: LotteryListViewModel
    var disposeBag = DisposeBag()
    
    init(viewModel: LotteryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var navigationBar = UIView()
    private var titleLabel = UILabel()
    private var searchButton = UIButton()
    private var lotteryTableView = LotteryTableView()
    
    private var refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
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
            .bind { $0.coordinator?.pushLotterySearchViewController(lottery: nil) }
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
    
}

// MARK: 테이블뷰 DataSource
extension LotteryListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.lotteryList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lotteryList[section].isOpen ? 2 : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: NumberCloseCell.cellId, for: indexPath) as! NumberCloseCell
            cell.bind(lottery: viewModel.lotteryList[indexPath.section])
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: NumberCell.cellId, for: indexPath) as! NumberCell
            cell.setData(lottery: viewModel.lotteryList[indexPath.section])

            cell.detailButtonHandler = { [weak self] in
                guard let self = self else { return }
                HapticManager.shared.hapticImpact(style: .soft)
                
                let lottery = self.viewModel.lotteryList[indexPath.section]
                self.coordinator?.pushLotterySearchViewController(lottery: lottery)
            }

            return cell
        }
    }

}

// MARK: 테이블뷰 Delegate
extension LotteryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 50
        default:
            return 220
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            viewModel.lotteryList[indexPath.section].isOpen.toggle()
            tableView.reloadSections([indexPath.section], with: .fade)

        default:
            return
        }
    }
    
}

private extension LotteryListViewController {
    
    private func initAttributes() {
        view.backgroundColor = .white
        
        titleLabel = UILabel().then {
            $0.text = "조회하기"
            $0.textAlignment = .center
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.bold(size: 18)
        }
        
        searchButton = UIButton().then {
            $0.tintColor = LottyColors.B500
            $0.setImage(LottyIcons.search, for: .normal)
        }
        
        lotteryTableView = LotteryTableView().then {
            $0.dataSource = self
            $0.delegate = self
            $0.refreshControl = refreshControl
        }
    }
    
    private func initConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
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
