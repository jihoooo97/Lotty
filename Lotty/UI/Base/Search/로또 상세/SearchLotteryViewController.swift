import UIKit
import Network
import RxSwift
import RxCocoa

class SearchLotteryViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lotteryView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var drwNo: UILabel!
    @IBOutlet weak var drwDate: UILabel!
    @IBOutlet weak var no1: UILabel!
    @IBOutlet weak var no2: UILabel!
    @IBOutlet weak var no3: UILabel!
    @IBOutlet weak var no4: UILabel!
    @IBOutlet weak var no5: UILabel!
    @IBOutlet weak var no6: UILabel!
    @IBOutlet weak var bonusNo: UILabel!
    @IBOutlet weak var winCount: UILabel!
    @IBOutlet weak var winAmount: UILabel!
    @IBOutlet weak var totalWinAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var clearView: UIView!
    @IBOutlet weak var historyTableView: UITableView!
    
    let monitor = NWPathMonitor()
    
    let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavi()
        
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "오류", message: "네트워크 연결을 확인해주세요", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                }
            }
        }
        
        contentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 464)
        lotteryView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 400)
        bottomView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60)
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        viewModel.loadHistory()
        if viewModel.lotteryInfo.drwNoDate != "" {
            if viewModel.lotteryInfo.firstAccumamnt == 0 {
                viewModel.lotteryInfo.firstAccumamnt = viewModel.lotteryInfo.firstPrzwnerCo * viewModel.lotteryInfo.firstWinamnt
            }
            lotteryConfigure()
        } else {
            lotteryView.isHidden = true
        }
        
        let width = UIScreen.main.bounds.width
        if lotteryView.isHidden {
            contentView.frame = CGRect(x: 0, y: 0, width: width, height: 60)
            bottomView.frame.origin = CGPoint(x: 0, y: 0)
        } else {
            contentView.frame = CGRect(x: 0, y: 0, width: width, height: 464)
            bottomView.frame.origin = CGPoint(x: 0, y: 400)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        viewModel.saveHistory()
        monitor.cancel()
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        image.draw(in: CGRect(origin: .zero, size: CGSize(width: newWidth, height: newWidth)))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    func configureNavi() {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.setImage(UIImage(named: "arrow_left_icon"), for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        backButton.tintColor = .BackButton
        backButton.sizeToFit()
        
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 70, height: 0))
        let scopeImage = resizeImage(image: UIImage(named: "find_icon")!, newWidth: 20)?.withTintColor(.Placeholder)
        searchBar.layer.cornerRadius = 8
        searchBar.searchTextField.leftView = UIImageView(image: scopeImage)
        searchBar.searchTextField.leftView?.contentMode = .scaleToFill
        searchBar.searchTextField.textColor = .G900
        searchBar.alpha = 0.6
        searchBar.searchTextField.backgroundColor = .G50
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "회차를 입력해주세요 ex) 1002",
            attributes: [.foregroundColor: UIColor.Placeholder,
                         .font: UIFont(name: "Pretendard-Regular", size: 16)!]
        )
        searchBar.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        lotteryView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        bottomView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        let clearTap = UITapGestureRecognizer(target: self, action: #selector(clearHistoy))
        clearView.addGestureRecognizer(clearTap)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
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
        setRound(label: no1)
        setRound(label: no2)
        setRound(label: no3)
        setRound(label: no4)
        setRound(label: no5)
        setRound(label: no6)
        setRound(label: bonusNo)
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
    
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
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
    
    @IBAction func tapView(_ sender: Any) {
        self.navigationItem.rightBarButtonItem?.customView?.resignFirstResponder()
    }
}

extension SearchLotteryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.historyList.count > 0 {
            return viewModel.historyList.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.historyList.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryCell else { return UITableViewCell() }
            cell.drwNo.text = "\(viewModel.historyList[indexPath.row])회"
            cell.clickButtonHandler = {
                self.navigationItem.rightBarButtonItem?.customView?.resignFirstResponder()
                if self.monitor.currentPath.status == .satisfied {
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
                } else {
                    let alert = UIAlertController(title: "오류", message: "네트워크 연결을 확인해주세요", preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(confirm)
                    self.present(alert, animated: true)
                }
            }
            cell.deleteButtonHandler = {
                self.viewModel.deleteHistory(index: indexPath.row)
                self.historyTableView.reloadData()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath) as? EmptyCell else { return UITableViewCell() }
            return cell
        }
    }
}

extension SearchLotteryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModel.historyList.count > 0 {
            return 50
        } else {
            return 150
        }
    }
}

extension SearchLotteryViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if monitor.currentPath.status == .satisfied {
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
        } else {
            let alert = UIAlertController(title: "오류", message: "네트워크 연결을 확인해주세요", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default)
            alert.addAction(confirm)
            self.present(alert, animated: true)
        }
    }
}
