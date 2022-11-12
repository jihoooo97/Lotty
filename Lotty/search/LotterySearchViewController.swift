import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class LotterySearchViewController: UIViewController, ViewController {
    
    var navigationBar = UIView()
    var backButton = UIButton()
    var searchBar = UISearchBar()
    
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
    var historyTitleLabel = UILabel()
    var historyClearButton = UIButton()
    var historyTableView = UITableView()
    
    var safeArea = UILayoutGuide()
    
    var lotteryInfo: LotteryItem?

    var viewModel: LotterySearchViewModel?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAttributes()
        initUI()
        inputBind()
        outputBind()
        
        setFirstInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        viewModel?.loadHistory()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        viewModel?.saveHistory()
    }
    
    func inputBind() {
        backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind(onNext: {
                $0.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        historyClearButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind(onNext: {
                $0.clearHistoy()
            }).disposed(by: disposeBag)
        
        historyTableView.rx.itemSelected
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { ($0.0, $0.1) }
            .bind(onNext: { (vc, index) in
                vc.searchBar.searchTextField.resignFirstResponder()
                vc.viewModel?.clickHistory(index: index.row)
            }).disposed(by: disposeBag)
    }
    
    func outputBind() {
        viewModel?.lotteryInfoRelay
            .observe(on: MainScheduler.instance)
            .withUnretained(self).map { ($0.0, $0.1) }
            .bind(onNext: { (vc, lottery) in
                guard let lottery = lottery else { return }
                vc.containerView.isHidden = false
                vc.historyTopIndicator.isHidden = false
                vc.drwNoTitleLabel.text = "\(lottery.drwNo)회"
                vc.dateLabel.text = lottery.drwNoDate
                vc.drwNo1Label.lotteryNo = lottery.drwtNo1
                vc.drwNo2Label.lotteryNo = lottery.drwtNo2
                vc.drwNo3Label.lotteryNo = lottery.drwtNo3
                vc.drwNo4Label.lotteryNo = lottery.drwtNo4
                vc.drwNo5Label.lotteryNo = lottery.drwtNo5
                vc.drwNo6Label.lotteryNo = lottery.drwtNo6
                vc.bonusNoLabel.lotteryNo = lottery.bnusNo
                vc.winCountLabel.text = "\(lottery.firstPrzwnerCo)" + "명"
                vc.winAmountLabel.text = lottery.firstWinamnt.numberFormatter() + "원"
                vc.totalWinAmountLabel.text = lottery.firstAccumamnt.numberFormatter() + "원"
                vc.totalAmountLabel.text = lottery.totSellamnt.numberFormatter() + "원"
            }).disposed(by: disposeBag)
        
        viewModel?.historyListRelay
            .observe(on: MainScheduler.instance)
            .bind(to: historyTableView.rx.items(
                cellIdentifier: HistoryCell.cellId,
                cellType: HistoryCell.self)
            ) { [weak self] (index, item, cell) in
                cell.drwNo.text = "\(item)회"
                
                cell.deleteButtonHandler = {
                    self?.viewModel?.deleteHistory(index: index)
                }
            }.disposed(by: disposeBag)
    }
    
    func setFirstInfo() {
        guard let lottery = lotteryInfo?.lottery else {
            containerView.isHidden = true
            historyTopIndicator.isHidden = true
            searchBar.searchTextField.becomeFirstResponder()
            return
        }
        self.drwNoTitleLabel.text = "\(lottery.drwNo)회"
        self.dateLabel.text = lottery.drwNoDate
        self.drwNo1Label.lotteryNo = lottery.drwtNo1
        self.drwNo2Label.lotteryNo = lottery.drwtNo2
        self.drwNo3Label.lotteryNo = lottery.drwtNo3
        self.drwNo4Label.lotteryNo = lottery.drwtNo4
        self.drwNo5Label.lotteryNo = lottery.drwtNo5
        self.drwNo6Label.lotteryNo = lottery.drwtNo6
        self.bonusNoLabel.lotteryNo = lottery.bnusNo
        self.winCountLabel.text = "\(lottery.firstPrzwnerCo)" + "명"
        self.winAmountLabel.text = lottery.firstWinamnt.numberFormatter() + "원"
        self.totalWinAmountLabel.text = lottery.firstAccumamnt.numberFormatter() + "원"
        self.totalAmountLabel.text = lottery.totSellamnt.numberFormatter() + "원"
    }
    
    func clearHistoy() {
        let alert = UIAlertController(title: "알림", message: "최근 조회 목록을 모두 삭제하시겠습니까?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { action in
            self.viewModel?.clearHistory()
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @objc func keyboardDown() {
        self.searchBar.searchTextField.resignFirstResponder()
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
        self.viewModel?.searchDrwNo(drwNo: Int(searchBar.text!) ?? 0)
        searchBar.text = ""
    }
    
}

extension LotterySearchViewController {
    
    func initAttributes() {
        view.backgroundColor = .white
        safeArea = view.safeAreaLayoutGuide
        
        let keyboardDown = UITapGestureRecognizer(target: self, action: #selector(keyboardDown))
        
        navigationBar = UIView().then {
            $0.backgroundColor = .white
        }
        
        backButton = UIButton().then {
            $0.tintColor = LottyColors.B500
            $0.setImage(LottyIcons.arrowLeft, for: .normal)
        }
        
        searchBar = UISearchBar().then {
            let scopeImage = LottyIcons.search.resize(width: 20).withTintColor(LottyColors.Placeholder)
            $0.searchTextField.layer.cornerRadius = 8
            $0.searchTextField.leftView = UIImageView(image: scopeImage)
            $0.searchTextField.leftView?.contentMode = .scaleToFill
            $0.searchTextField.textColor = LottyColors.G900
            $0.searchTextField.backgroundColor = LottyColors.G50
            $0.searchTextField.attributedPlaceholder = NSAttributedString(
                string: "회차를 입력해주세요 ex) 1002",
                attributes: [.foregroundColor: LottyColors.Placeholder,
                             .font: UIFont(name: "Pretendard-Regular", size: 16)!]
            )
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
            $0.backgroundColor = .white
            $0.barTintColor = .white
            $0.keyboardType = .numberPad
            $0.delegate = self
        }
        
        stackView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
//            $0.spacing = 48
            $0.backgroundColor = .white
//            $0.isLayoutMarginsRelativeArrangement = true
//            $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 48, trailing: 0)
        }
        
        // MARK: LotteryView
        containerView = UIView().then {
            $0.backgroundColor = .white
            $0.addGestureRecognizer(keyboardDown)
        }
        
        drwNoTitleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.semiBold(size: 19)
            $0.text = "0000회"
        }
        
        dateLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.Placeholder
            $0.font = LottyFonts.medium(size: 15)
            $0.text = "0000-00-00"
        }
        
        lotteryContainerView = UIView().then {
            $0.backgroundColor = .white
        }
        
        plusImage = UIImageView().then {
            $0.image = LottyIcons.plus
            $0.tintColor = LottyColors.G600
        }
        
        winCountTitleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.B500
            $0.font = LottyFonts.semiBold(size: 16)
            $0.text = "당첨자 수"
        }
        
        winCountLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.medium(size: 16)
            $0.text = "0"
        }
        
        winAmountTitleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.B500
            $0.font = LottyFonts.semiBold(size: 16)
            $0.text = "1인 당첨 금액"
        }
        
        winAmountLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.medium(size: 16)
            $0.text = "0"
        }
        
        totalWinAmountTitleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.B500
            $0.font = LottyFonts.semiBold(size: 16)
            $0.text = "총 당첨 금액"
        }
        
        totalWinAmountLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.medium(size: 16)
            $0.text = "0"
        }
        
        totalAmountTitleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.B500
            $0.font = LottyFonts.semiBold(size: 16)
            $0.text = "총 복권 판매 금액"
        }
        
        totalAmountLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.medium(size: 16)
            $0.text = "0"
        }
        
        indicator1 = UIView().then {
            $0.backgroundColor = LottyColors.G50
        }
        
        indicator2 = UIView().then {
            $0.backgroundColor = LottyColors.G50
        }
        
        indicator3 = UIView().then {
            $0.backgroundColor = LottyColors.G50
        }
        
        // MARK: HistoryView
        historyTopIndicator = UIView().then {
            $0.backgroundColor = LottyColors.G50
        }
        
        historyTopView = UIView().then {
            $0.backgroundColor = .white
        }
        
        historyTitleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.Placeholder
            $0.font = LottyFonts.semiBold(size: 15)
            $0.text = "최근 본 회차"
        }
        
        historyClearButton = UIButton().then {
            $0.setTitle("전체 삭제", for: .normal)
            $0.setTitleColor(LottyColors.Placeholder, for: .normal)
            $0.titleLabel?.font = LottyFonts.semiBold(size: 13)
            let clearImage = LottyIcons.trashIcon.resize(width: 15).withTintColor(LottyColors.Placeholder)
            $0.setImage(clearImage, for: .normal)
        }
        
        historyTableView = UITableView().then {
            $0.backgroundColor = .white
            $0.separatorStyle = .none
//            $0.allowsSelection = false
            $0.keyboardDismissMode = .onDrag
            $0.delegate = self
            $0.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.cellId)
        }
    }
    
    func initUI() {
        [navigationBar, stackView]
            .forEach { view.addSubview($0) }

        navigationBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeArea)
            $0.height.equalTo(44)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.equalTo(safeArea)
        }
        
        [backButton, searchBar]
            .forEach { navigationBar.addSubview($0) }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        
        searchBar.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        [containerView, historyTopIndicator, historyTopView, historyTableView]
            .forEach { stackView.addArrangedSubview($0) }
        
        [historyTitleLabel, historyClearButton]
            .forEach { historyTopView.addSubview($0) }
        
        containerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(400)
        }
        
        historyTopIndicator.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        historyTopView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(66)
        }
        
        historyTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
        }
        
        historyClearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-26)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        historyTableView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        [drwNoTitleLabel, dateLabel, lotteryContainerView,
         winCountTitleLabel, winCountLabel,
         winAmountTitleLabel, winAmountLabel,
         totalWinAmountTitleLabel, totalWinAmountLabel,
         totalAmountTitleLabel, totalAmountLabel,
         indicator1, indicator2, indicator3]
            .forEach { containerView.addSubview($0) }
        
        [drwNo1Label, drwNo2Label, drwNo3Label, drwNo4Label,
         drwNo5Label, drwNo6Label, plusImage, bonusNoLabel]
            .forEach { lotteryContainerView.addSubview($0) }
        
        drwNoTitleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(24)
        }
        
        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalTo(drwNoTitleLabel)
        }
        
        lotteryContainerView.snp.makeConstraints {
            $0.leading.equalTo(drwNo1Label)
            $0.trailing.equalTo(bonusNoLabel)
            $0.top.equalTo(drwNoTitleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        drwNo1Label.snp.makeConstraints {
            $0.centerY.equalTo(lotteryContainerView)
            $0.width.height.equalTo(36)
        }
        
        drwNo2Label.snp.makeConstraints {
            $0.leading.equalTo(drwNo1Label.snp.trailing).offset(5)
            $0.centerY.equalTo(lotteryContainerView)
            $0.width.height.equalTo(36)
        }
        
        drwNo3Label.snp.makeConstraints {
            $0.leading.equalTo(drwNo2Label.snp.trailing).offset(5)
            $0.centerY.equalTo(lotteryContainerView)
            $0.width.height.equalTo(36)
        }
        
        drwNo4Label.snp.makeConstraints {
            $0.leading.equalTo(drwNo3Label.snp.trailing).offset(5)
            $0.centerY.equalTo(lotteryContainerView)
            $0.width.height.equalTo(36)
        }
        
        drwNo5Label.snp.makeConstraints {
            $0.leading.equalTo(drwNo4Label.snp.trailing).offset(5)
            $0.centerY.equalTo(lotteryContainerView)
            $0.width.height.equalTo(36)
        }
        
        drwNo6Label.snp.makeConstraints {
            $0.leading.equalTo(drwNo5Label.snp.trailing).offset(5)
            $0.centerY.equalTo(lotteryContainerView)
            $0.width.height.equalTo(36)
        }
        
        plusImage.snp.makeConstraints {
            $0.leading.equalTo(drwNo6Label.snp.trailing).offset(5)
            $0.centerY.equalTo(lotteryContainerView)
            $0.width.height.equalTo(20)
        }
        
        bonusNoLabel.snp.makeConstraints {
            $0.leading.equalTo(plusImage.snp.trailing).offset(5)
            $0.centerY.equalTo(lotteryContainerView)
            $0.width.height.equalTo(36)
        }
        
        winCountTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(lotteryContainerView.snp.bottom).offset(20)
        }
        
        winCountLabel.snp.makeConstraints {
            $0.leading.equalTo(winCountTitleLabel)
            $0.top.equalTo(winCountTitleLabel.snp.bottom).offset(8)
        }
        
        indicator1.snp.makeConstraints {
            $0.leading.equalTo(winCountTitleLabel)
            $0.top.equalTo(winCountLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        winAmountTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(winCountTitleLabel)
            $0.top.equalTo(indicator1.snp.bottom).offset(12)
        }
        
        winAmountLabel.snp.makeConstraints {
            $0.leading.equalTo(winCountTitleLabel)
            $0.top.equalTo(winAmountTitleLabel.snp.bottom).offset(8)
        }
        
        indicator2.snp.makeConstraints {
            $0.leading.equalTo(winCountTitleLabel)
            $0.top.equalTo(winAmountLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        totalWinAmountTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(winCountTitleLabel)
            $0.top.equalTo(indicator2.snp.bottom).offset(12)
        }
        
        totalWinAmountLabel.snp.makeConstraints {
            $0.leading.equalTo(winCountTitleLabel)
            $0.top.equalTo(totalWinAmountTitleLabel.snp.bottom).offset(8)
        }
        
        indicator3.snp.makeConstraints {
            $0.leading.equalTo(winCountTitleLabel)
            $0.top.equalTo(totalWinAmountLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        totalAmountTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(winCountTitleLabel)
            $0.top.equalTo(indicator3.snp.bottom).offset(12)
        }
        
        totalAmountLabel.snp.makeConstraints {
            $0.leading.equalTo(winCountTitleLabel)
            $0.top.equalTo(totalAmountTitleLabel.snp.bottom).offset(8)
        }
    }
    
}
