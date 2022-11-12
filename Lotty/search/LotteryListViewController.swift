import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class LotteryListViewController: UIViewController {
    
    var navigationBar = UIView()
    var titleLabel = UILabel()
    var searchButton = UIButton()
    var lotteyTableView = UITableView()
    
    var safeArea = UILayoutGuide()
    private var refreshControl = UIRefreshControl()
    
    let viewModel = LotteryListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initattributes()
        initUI()
        inputBind()
        outputBind()
        
        viewModel.getRecentNumber()
        viewModel.getLotteryNumber(drwNo: viewModel.recentNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .white
        viewModel.loadHistory()
    }
    
    func inputBind() {
        searchButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind(onNext: {
                let viewModel = LotterySearchViewModel()
                let lotterySearchViController = LotterySearchViewController(viewModel)
                $0.navigationController?.pushViewController(lotterySearchViController, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func outputBind() {
        // section 처리가 곤란함
//        viewModel.lotteryListRelay
//            .filter { $0.count >= 0 }
//            .observe(on: MainScheduler.instance)
//            .bind(to: tableView.rx.items(
//                cellIdentifier: "numberCell",
//                cellType: NumberCell.self
//            )) { (index, item, cell) in
//
//            }.disposed(by: disposeBag)
        
        viewModel.lotteryListRelay
            .bind(onNext: { [weak self] lotteryList in
                self?.lotteyTableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    @objc func pullToRefresh() {
        viewModel.lotteryItems = []
        viewModel.page = 0
        viewModel.getRecentNumber()
        
        self.viewModel.getLotteryNumber(drwNo: self.viewModel.recentNumber)
        self.lotteyTableView.refreshControl?.endRefreshing()
    }
    
}

// MARK: 테이블뷰 DataSource
extension LotteryListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.lotteryItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.lotteryItems[section].open == true { return 2 }
        else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NumberCloseCell.cellId, for: indexPath) as! NumberCloseCell
            cell.setData(lottery: viewModel.lotteryItems[indexPath.section])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NumberCell.cellId, for: indexPath) as! NumberCell
            let lotteryItem = viewModel.lotteryListRelay.value
            
            cell.setData(lottery: lotteryItem[indexPath.section])
            
            cell.detailButtonHandler = { [weak self] in
                let lotteryInfo = self?.viewModel.lotteryListRelay.value[indexPath.section]
                self?.viewModel.updateHistory(section: indexPath.section)
                self?.viewModel.saveHistory()
                let lotterySearchViewController = LotterySearchViewController(LotterySearchViewModel())
                lotterySearchViewController.lotteryInfo = lotteryInfo
                self?.navigationController?.pushViewController(lotterySearchViewController  , animated: true)
            }
            
            return cell
        }
    }
    
}

// MARK: 테이블뷰 Delegate
extension LotteryListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return 50 }
        else { return 220 }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let cell = tableView.cellForRow(at: indexPath) as? NumberCloseCell else { return }
            guard let index = tableView.indexPath(for: cell) else { return }
            if index.row == indexPath.row && index.row == 0 {
                if viewModel.lotteryItems[indexPath.section].open == true {
                    viewModel.lotteryItems[indexPath.section].open = false
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .fade)
                } else {
                    viewModel.lotteryItems[indexPath.section].open = true
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .fade)
                }
            }
        }
    }
    
}

// MARK: 무한 스크롤
extension LotteryListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset_y = lotteyTableView.contentOffset.y
        let tableViewContentSize = lotteyTableView.contentSize.height
        let pagination_y = lotteyTableView.bounds.size.height

        if contentOffset_y > (tableViewContentSize - pagination_y) && contentOffset_y > 0 {
            if !viewModel.fetchingMore {
                beingFetch()
            }
        }
    }
    
    // 페이지 갱신
    func beingFetch() {
        viewModel.fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.viewModel.page += 1
            let count = self.viewModel.recentNumber - (self.viewModel.page * 10)
            if count > 10 {
                self.viewModel.getLotteryNumber(drwNo: count)
                self.viewModel.fetchingMore = false
            } else if count <= 10 && count > 0{
                for i in 1...count {
                    self.viewModel.getLotteryNumber(drwNo: i)
                }
                self.viewModel.fetchingMore = false
            }
        }
    }
    
}

extension LotteryListViewController {
    
    func initattributes() {
        view.backgroundColor = .white
        safeArea = view.safeAreaLayoutGuide
        
        navigationBar = UIView().then {
            $0.backgroundColor = .clear
        }
        
        titleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.bold(size: 18)
            $0.text = "조회하기"
        }
        
        searchButton = UIButton().then {
            $0.tintColor = LottyColors.B500
            $0.setImage(LottyIcons.search, for: .normal)
        }
        
        lotteyTableView = UITableView().then {
            $0.backgroundColor = .white
            $0.dataSource = self
            $0.delegate = self
            $0.separatorStyle = .none
            $0.refreshControl = refreshControl
            $0.refreshControl?.tintColor = LottyColors.AlphaB600
            $0.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
            $0.register(NumberCell.self, forCellReuseIdentifier: NumberCell.cellId)
            $0.register(NumberCloseCell.self, forCellReuseIdentifier: NumberCloseCell.cellId)
        }
    }
    
    func initUI() {
        [navigationBar, lotteyTableView]
            .forEach { view.addSubview($0) }
        
        [titleLabel, searchButton]
            .forEach { navigationBar.addSubview($0) }
        
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
            $0.width.height.equalTo(20)
        }
        
        lotteyTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.equalTo(safeArea)
        }
    }
    
}
