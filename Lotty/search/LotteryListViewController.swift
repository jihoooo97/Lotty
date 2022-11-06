import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LotteryListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl = UIRefreshControl()
    
    let viewModel = LotteryListViewModel()
    let disposeBag = DisposeBag()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailLottery" {
            let vc = segue.destination as! SearchLotteryViewController
            vc.viewModel.lotteryInfo = sender as! LotteryInfo
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.tintColor = .AlphaB600
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        configureNavi()
        outputBind()
        
        viewModel.getRecentNumber()
        viewModel.getLotteryNumber(drwNo: viewModel.recentNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .white
        viewModel.loadHistory()
    }
    
    func outputBind() {
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
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    func configureNavi() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 65, height: 44))
        label.text = "조회하기"
        label.textColor = .G900
        label.font = UIFont(name: "Pretendard-Bold", size: 18)!
        customView.addSubview(label)
        
        let leftButton = UIBarButtonItem(customView: customView)
        self.navigationItem.leftBarButtonItem = leftButton
//        self.navigationController?.navigationBar.titleTextAttributes = [
//            .foregroundColor: UIColor.G900,
//            .font: UIFont(name: "Pretendard-Bold", size: 18)!
//        ]
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // 글자 간격
//        let attrString = NSMutableAttributedString(string: explainLabel.text!)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 6
//        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
//        explainLabel.attributedText = attrString
    }
    
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    @objc func pullToRefresh() {
        viewModel.lotteryItems = []
        viewModel.page = 0
        viewModel.getRecentNumber()
        // [!] 테이블뷰 갱신 오류
        self.viewModel.getLotteryNumber(drwNo: self.viewModel.recentNumber)
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "numberCloseCell", for: indexPath) as? NumberCloseCell else { return UITableViewCell() }
            if viewModel.lotteryItems[indexPath.section].open == true {
                cell.status.image = UIImage(named: "arrow_up_icon")
            } else {
                cell.status.image = UIImage(named: "arrow_down_icon")
            }
            cell.drwNo.text = "\(viewModel.lotteryItems[indexPath.section].lottery.drwNo)회"
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "numberCell", for: indexPath) as? NumberCell else { return FailCell() }
            let lotteryItem = viewModel.lotteryListRelay.value
            cell.date.text = lotteryItem[indexPath.section].lottery.drwNoDate
            cell.no1.text = "\(lotteryItem[indexPath.section].lottery.drwtNo1)"
            cell.no2.text = "\(lotteryItem[indexPath.section].lottery.drwtNo2)"
            cell.no3.text = "\(lotteryItem[indexPath.section].lottery.drwtNo3)"
            cell.no4.text = "\(lotteryItem[indexPath.section].lottery.drwtNo4)"
            cell.no5.text = "\(lotteryItem[indexPath.section].lottery.drwtNo5)"
            cell.no6.text = "\(lotteryItem[indexPath.section].lottery.drwtNo6)"
            cell.bonusNo.text = "\(lotteryItem[indexPath.section].lottery.bnusNo)"
            cell.winCount.text = "총 \(lotteryItem[indexPath.section].lottery.firstPrzwnerCo)명 당첨"
            cell.winAmount.text = numberFormatter(number: lotteryItem[indexPath.section].lottery.firstWinamnt) + "원"
            cell.detailButtonHandler = {
                self.viewModel.updateHistory(section: indexPath.section)
                self.viewModel.saveHistory()
                self.performSegue(withIdentifier: "detailLottery", sender: lotteryItem[indexPath.section].lottery)
            }
            setRound(label: cell.no1)
            setRound(label: cell.no2)
            setRound(label: cell.no3)
            setRound(label: cell.no4)
            setRound(label: cell.no5)
            setRound(label: cell.no6)
            setRound(label: cell.bonusNo)
            return cell
        }
    }
    
    func setRound(label: UILabel) {
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 18
        if Int(label.text!)! <= 10 {
            label.backgroundColor = .firstColor
        } else if Int(label.text!)! <= 20 {
            label.backgroundColor = .secondColor
        } else if Int(label.text!)! <= 30 {
            label.backgroundColor = .thirdColor
        } else if Int(label.text!)! <= 40 {
            label.backgroundColor = .fourthColor
        } else {
            label.backgroundColor = .fifthColor
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

// MARK: 무한 스크롤
extension LotteryListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset_y = tableView.contentOffset.y
        let tableViewContentSize = tableView.contentSize.height
        let pagination_y = tableView.bounds.size.height

        if contentOffset_y > (tableViewContentSize - pagination_y) && contentOffset_y > 0 {
            if !viewModel.fetchingMore {
                beingFetch()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        self.tableView.reloadData()
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
