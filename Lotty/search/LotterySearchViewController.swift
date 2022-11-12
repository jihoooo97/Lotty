import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class LotterySearchViewController: BaseViewController<LotterySearchViewModel> {
    
    var navigationBar = UIView()
    var backButton = UIButton()
    var searchTextField = UITextField()
    
    var stackView = UIStackView()
    
    // MARK: LotteryView
    var containerView = UIView()
    var drwNoTitleLabel = UILabel()
    var dateLabel = UILabel()
    
    var lotteryContainerView = UIView()
    var drwNo1Label = LotteryLabel()
    var drwNo2Label = LotteryLabel()
    var drwNo3Label = LotteryLabel()
    var drwNo4Label = LotteryLabel()
    var drwNo5Label = LotteryLabel()
    var drwNo6Label = LotteryLabel()
    var bonusNoLabel = LotteryLabel()
    var plusImage = UIImageView()
    
    var winCountTitleLabel = UILabel()
    var winCountLabel = UILabel()
    var winAmountTitleLabel = UILabel()
    var winAmountLabel = UILabel()
    var totalWinAmountTitleLabel = UILabel()
    var totalWinAmountLabel = UILabel()
    var totalAmountTitleLabel = UILabel()
    var totalAmountLabel = UILabel()
    
    var indicator1 = UIView()
    var indicator2 = UIView()
    var indicator3 = UIView()
    
    // MARK: HistoryView
    var historyTopIndicator = UIView()
    var historyTopView = UIView()
    var historyTableView = UITableView()

    var safeArea = UILayoutGuide()
    
    var lotteryInfo: LotteryItem?

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAttributes()
        initUI()
        inputbind()
        outputBind()
        
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        viewModel.loadHistory()
        if lotteryInfo != nil {
            lotteryConfigure()
        } else {
            containerView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        viewModel.saveHistory()
    }
    
    func inputbind() {
        
    }
    
    func outputBind() {
        
    }
    
    func configureNavi() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "arrow_left_icon"), for: .normal)
        backButton.tintColor = LottyColors.BackButton
        
        let searchBar = UISearchBar()
        let scopeImage = resizeImage(image: UIImage(named: "find_icon")!, newWidth: 20)?.withTintColor(LottyColors.Placeholder)
        searchBar.layer.cornerRadius = 8
        searchBar.searchTextField.leftView = UIImageView(image: scopeImage)
        searchBar.searchTextField.leftView?.contentMode = .scaleToFill
        searchBar.searchTextField.textColor = LottyColors.G900
        searchBar.searchTextField.backgroundColor = LottyColors.G50
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "회차를 입력해주세요 ex) 1002",
            attributes: [.foregroundColor: LottyColors.Placeholder,
                         .font: UIFont(name: "Pretendard-Regular", size: 16)!]
        )
        searchBar.delegate = self
        
//        let clearTap = UITapGestureRecognizer(target: self, action: #selector(clearHistoy))
//        clearView.addGestureRecognizer(clearTap)
    }
    
    func lotteryConfigure() {
        drwNo.text = "\(viewModel.lotteryInfo.drwNo)회"
        drwDate.text = viewModel.lotteryInfo.drwNoDate
        no1.text = "\(viewModel.lotteryInfo.drwtNo1)"
        no2.text = "\(viewModel.lotteryInfo.drwtNo2)"
        no3.text = "\(viewModel.lotteryInfo.drwtNo3)"
        no4.text = "\(viewModel.lotteryInfo.drwtNo4)"
        no5.text = "\(viewModel.lotteryInfo.drwtNo5)"
        no6.text = "\(viewModel.lotteryInfo.drwtNo6)"
        bonusNo.text = "\(viewModel.lotteryInfo.bnusNo)"
        winCount.text = "\(viewModel.lotteryInfo.firstPrzwnerCo)명"
        winAmount.text = "\(numberFormatter(number: viewModel.lotteryInfo.firstWinamnt))원"
        totalWinAmount.text = "\(numberFormatter(number: viewModel.lotteryInfo.firstAccumamnt))원"
        totalAmount.text = "\(numberFormatter(number: viewModel.lotteryInfo.totSellamnt))원"
    }
    
    @objc func clearHistoy() {
        let alert = UIAlertController(title: "알림", message: "최근 조회 목록을 모두 삭제하시겠습니까?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { action in
            self.viewModel.clearHistory()
            self.historyTableView.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
}


extension LotterySearchViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        
        cell.drwNo.text = "\(viewModel.historyList[indexPath.row])회"
        
        cell.clickButtonHandler = {
            self.navigationItem.rightBarButtonItem?.customView?.resignFirstResponder()
            if self.lotteryView.isHidden {
                self.lotteryView.isHidden = false
                let width = UIScreen.main.bounds.width
                self.contentView.frame = CGRect(x: 0, y: 0, width: width, height: 464)
                self.bottomView.frame.origin = CGPoint(x: 0, y: 400)
            }
            if cell.drwNo.text != self.drwNo.text {
                // [!] viewModel 갱신 전 뷰 처리 이슈
                self.viewModel.clickHistory(index: indexPath.row)
                self.lotteryConfigure()
                self.historyTableView.reloadData()
            }
        }
        
        cell.deleteButtonHandler = {
            self.viewModel.deleteHistory(index: indexPath.row)
            self.historyTableView.reloadData()
        }
        
        return cell
    }
    
}

extension LotterySearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

extension LotterySearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if self.lotteryView.isHidden {
            self.lotteryView.isHidden = false
            let width = UIScreen.main.bounds.width
            self.contentView.frame = CGRect(x: 0, y: 0, width: width, height: 464)
            self.bottomView.frame.origin = CGPoint(x: 0, y: 400)
        }
        // [!] viewModel 갱신 전 뷰 처리 이슈
        self.viewModel.searchDrwNo(drwNo: searchBar.text!)
        self.lotteryConfigure()
        self.historyTableView.reloadData()
        searchBar.text = ""
    }

}

extension LotterySearchViewController: ViewController {
    
    func initAttributes() {
        
    }
    
    func initUI() {
        
    }
    
}
